// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// XSim-compatible directed check for the centralized DMA footprint helpers and setup rejection.
//
// This deliberately does not replace dma_mem_boundary_vseq. It exercises the actual helper
// functions and the DmaAddrSetup error/no-request path compiled inside dma.sv without depending
// on UVM constraint features that XSim does not implement. The campaign closeout records that
// limitation explicitly.
module dma_footprint_xsim_tb;
  import dma_pkg::*;
  import dma_reg_pkg::*;

  logic clk_i = 1'b0;
  logic rst_ni = 1'b0;
  prim_mubi_pkg::mubi4_t scanmode_i = prim_mubi_pkg::MuBi4False;
  lsio_trigger_t lsio_trigger_i = '0;
  prim_alert_pkg::alert_rx_t [NumAlerts-1:0] alert_rx_i = '0;
  prim_alert_pkg::alert_tx_t [NumAlerts-1:0] alert_tx_o;
  top_racl_pkg::racl_policy_vec_t racl_policies_i = '0;
  top_racl_pkg::racl_error_log_t racl_error_o;
  tlul_pkg::tl_h2d_t tl_d_i = '0;
  tlul_pkg::tl_d2h_t tl_d_o;
  tlul_pkg::tl_d2h_t ctn_tl_d2h_i = '0;
  tlul_pkg::tl_h2d_t ctn_tl_h2d_o;
  tlul_pkg::tl_d2h_t host_tl_h_i = '0;
  tlul_pkg::tl_h2d_t host_tl_h_o;
  sys_rsp_t sys_i = '0;
  sys_req_t sys_o;
  logic intr_dma_done_o;
  logic intr_dma_chunk_done_o;
  logic intr_dma_error_o;

  int unsigned checks;
  int unsigned failures;

  // XSim does not reliably retain automatic task inputs on the right-hand side of a
  // hierarchical force. Copy each setup into static module variables before forcing the DUT.
  dma_reg2hw_t forced_reg2hw;
  control_state_t forced_control;

  always #5ns clk_i = ~clk_i;

  dma #(
    .EnableDataIntgGen(1'b0),
    .EnableRspDataIntgCheck(1'b0)
  ) dut (
    .clk_i,
    .rst_ni,
    .scanmode_i,
    .intr_dma_done_o,
    .intr_dma_chunk_done_o,
    .intr_dma_error_o,
    .lsio_trigger_i,
    .alert_rx_i,
    .alert_tx_o,
    .racl_policies_i,
    .racl_error_o,
    .tl_d_i,
    .tl_d_o,
    .ctn_tl_d2h_i,
    .ctn_tl_h2d_o,
    .host_tl_h_i,
    .host_tl_h_o,
    .sys_i,
    .sys_o
  );

  task automatic check_size(
    input string name,
    input logic increment,
    input logic wrap,
    input logic [1:0] width,
    input logic [31:0] total_size,
    input logic [31:0] chunk_size,
    input logic [32:0] expected
  );
    logic [32:0] observed;
    observed = dut.address_footprint_size(increment, wrap, width, total_size, chunk_size);
    checks++;
    if (observed !== expected) begin
      failures++;
      $error("%s: footprint size observed 0x%0h, expected 0x%0h", name, observed, expected);
    end
  endtask

  // Hardware-handshake interrupt clearing must not bypass configuration validation. Check the
  // first combinational transition after a trigger; the next DmaAddrSetup cycle is covered by the
  // rejected-setup checks below.
  task check_handshake_trigger_validates_before_clear();
    forced_reg2hw = '0;
    forced_reg2hw.control.go.q = 1'b1;
    forced_reg2hw.control.initial_transfer.q = 1'b1;
    forced_reg2hw.control.hardware_handshake_enable.q = 1'b1;
    forced_reg2hw.clear_intr_src.q[0] = 1'b1;
    forced_reg2hw.handshake_intr_enable.q[0] = 1'b1;
    forced_control = '0;
    forced_control.cfg_handshake_en = 1'b1;

    lsio_trigger_i[0] = 1'b1;
    force dut.ctrl_state_q = DmaIdle;
    force dut.control_q = forced_control;
    force dut.reg2hw = forced_reg2hw;
    #1ns;

    checks += 2;
    if (dut.ctrl_state_d !== DmaAddrSetup) begin
      failures++;
      $error("handshake trigger bypassed DmaAddrSetup validation");
    end
    if (dut.dma_host_tlul_req_valid || dut.dma_ctn_tlul_req_valid ||
        dut.dma_sys_read || dut.dma_sys_write) begin
      failures++;
      $error("handshake trigger emitted a request before configuration validation");
    end

    release dut.ctrl_state_q;
    release dut.control_q;
    release dut.reg2hw;
    lsio_trigger_i = '0;
    #1ns;
  endtask

  task check_valid_handshake_clear_path();
    forced_reg2hw = '0;
    forced_reg2hw.addr_space_id.src_asid.q = SocControlAddr;
    forced_reg2hw.addr_space_id.dst_asid.q = OtInternalAddr;
    forced_reg2hw.src_addr_lo.q = 32'h0000_2000;
    forced_reg2hw.dst_addr_lo.q = 32'h0000_1000;
    forced_reg2hw.src_config.increment.q = 1'b1;
    forced_reg2hw.dst_config.increment.q = 1'b1;
    forced_reg2hw.transfer_width.q = DmaXfer1BperTxn;
    forced_reg2hw.total_data_size.q = 32'd16;
    forced_reg2hw.chunk_data_size.q = 32'd8;
    forced_reg2hw.clear_intr_src.q[0] = 1'b1;
    forced_control = '0;
    forced_control.opcode = OpcCopy;
    forced_control.cfg_handshake_en = 1'b1;
    forced_control.range_valid = 1'b1;
    forced_control.enabled_memory_range_base = 32'h0000_1000;
    forced_control.enabled_memory_range_limit = 32'h0000_100f;

    force dut.ctrl_state_q = DmaAddrSetup;
    force dut.transfer_byte_q = 32'd0;
    force dut.control_q = forced_control;
    force dut.reg2hw = forced_reg2hw;
    force dut.intr_clear_done_q = 1'b0;
    #1ns;

    checks += 2;
    if (dut.ctrl_state_d !== DmaClearIntrSrc) begin
      failures++;
      $error("valid handshake setup did not enter interrupt clearing");
    end
    if (dut.dma_host_tlul_req_valid || dut.dma_ctn_tlul_req_valid ||
        dut.dma_sys_read || dut.dma_sys_write) begin
      failures++;
      $error("valid handshake setup emitted a data request before interrupt clearing");
    end

    force dut.intr_clear_done_q = 1'b1;
    #1ns;
    checks++;
    if (dut.ctrl_state_d !== DmaSendRead) begin
      failures++;
      $error("validated handshake setup did not proceed after interrupt clearing");
    end

    release dut.ctrl_state_q;
    release dut.transfer_byte_q;
    release dut.control_q;
    release dut.reg2hw;
    release dut.intr_clear_done_q;
    #1ns;
  endtask

  task automatic check_invalid(
    input string name,
    input logic [31:0] address,
    input logic [32:0] footprint_size,
    input logic increment,
    input logic wrap,
    input logic [1:0] width,
    input logic full_word_read,
    input logic check_32bit,
    input logic check_range,
    input logic [31:0] range_base,
    input logic [31:0] range_limit,
    input logic expected
  );
    logic observed;
    observed = dut.address_footprint_invalid(address, footprint_size, increment, wrap, width,
                                             full_word_read, check_32bit, check_range, range_base,
                                             range_limit);
    checks++;
    if (observed !== expected) begin
      failures++;
      $error("%s: invalid observed %0b, expected %0b", name, observed, expected);
    end
  endtask

  task automatic check_composed_footprint(
    input string name,
    input logic [31:0] address,
    input logic increment,
    input logic wrap,
    input logic [1:0] width,
    input logic [31:0] total_size,
    input logic [31:0] chunk_size,
    input logic full_word_read,
    input logic [31:0] range_base,
    input logic [31:0] range_limit,
    input logic [32:0] expected_size,
    input logic expected_invalid
  );
    logic [32:0] observed_size;
    logic observed_invalid;

    observed_size = dut.address_footprint_size(
        increment, wrap, width, total_size, chunk_size);
    observed_invalid = dut.address_footprint_invalid(
        address, observed_size, increment, wrap, width, full_word_read, 1'b1, 1'b1,
        range_base, range_limit);
    checks += 2;
    if (observed_size !== expected_size) begin
      failures++;
      $error("%s: composed size observed 0x%0h, expected 0x%0h",
             name, observed_size, expected_size);
    end
    if (observed_invalid !== expected_invalid) begin
      failures++;
      $error("%s: composed invalid observed %0b, expected %0b",
             name, observed_invalid, expected_invalid);
    end
  endtask

  // Exercise the actual DmaAddrSetup rejection path as an assertion-equivalent structural check.
  // This is intentionally narrow: the full UVM sequence remains the behavioral bus-level check.
  task check_rejected_setup_no_requests(
    input string name,
    input dma_transfer_width_e width,
    input logic [31:0] total_size,
    input logic [31:0] chunk_size,
    input asid_encoding_e src_asid_value,
    input asid_encoding_e dst_asid_value,
    input logic [31:0] src_addr,
    input logic [31:0] dst_addr,
    input logic src_increment,
    input logic src_wrap,
    input logic dst_increment,
    input logic dst_wrap,
    input logic [31:0] range_base,
    input logic [31:0] range_limit,
    input dma_error_e expected_error
  );
    forced_reg2hw = '0;
    forced_reg2hw.addr_space_id.src_asid.q = src_asid_value;
    forced_reg2hw.addr_space_id.dst_asid.q = dst_asid_value;
    forced_reg2hw.src_addr_lo.q = src_addr;
    forced_reg2hw.dst_addr_lo.q = dst_addr;
    forced_reg2hw.src_config.increment.q = src_increment;
    forced_reg2hw.src_config.wrap.q = src_wrap;
    forced_reg2hw.dst_config.increment.q = dst_increment;
    forced_reg2hw.dst_config.wrap.q = dst_wrap;
    forced_reg2hw.transfer_width.q = width;
    forced_reg2hw.total_data_size.q = total_size;
    forced_reg2hw.chunk_data_size.q = chunk_size;
    forced_control = '0;
    forced_control.opcode = OpcCopy;
    forced_control.range_valid = 1'b1;
    forced_control.enabled_memory_range_base = range_base;
    forced_control.enabled_memory_range_limit = range_limit;

    force dut.ctrl_state_q = DmaAddrSetup;
    force dut.transfer_byte_q = 32'd0;
    force dut.control_q = forced_control;
    force dut.reg2hw = forced_reg2hw;
    #1ns;

    checks += 3;
    if (dut.next_error[int'(expected_error)] !== 1'b1) begin
      failures++;
      $error("%s: expected error bit %0d was not set (next_error=0x%0h)",
             name, expected_error, dut.next_error);
    end
    if (dut.ctrl_state_d !== DmaError) begin
      failures++;
      $error("%s: setup did not transition to DmaError", name);
    end
    if (dut.dma_host_tlul_req_valid || dut.dma_ctn_tlul_req_valid ||
        dut.dma_sys_read || dut.dma_sys_write) begin
      failures++;
      $error("%s: rejected setup emitted a DMA data-bus request", name);
    end

    release dut.ctrl_state_q;
    release dut.transfer_byte_q;
    release dut.control_q;
    release dut.reg2hw;
    #1ns;
  endtask

  initial begin
    repeat (2) @(posedge clk_i);
    rst_ni = 1'b1;
    repeat (2) @(posedge clk_i);

    // Reachable logical footprint by addressing mode and supported transfer width.
    check_size("nonwrap-1B-complete-transfer", 1'b1, 1'b0, DmaXfer1BperTxn,
               32'd16, 32'd4, 33'd16);
    check_size("nonwrap-2B-complete-transfer", 1'b1, 1'b0, DmaXfer2BperTxn,
               32'd16, 32'd4, 33'd16);
    check_size("nonwrap-4B-complete-transfer", 1'b1, 1'b0, DmaXfer4BperTxn,
               32'd16, 32'd8, 33'd16);
    check_size("chunk-wrap-bounded-by-chunk", 1'b1, 1'b1, DmaXfer2BperTxn,
               32'd16, 32'd6, 33'd6);
    check_size("chunk-wrap-final-short-chunk", 1'b1, 1'b1, DmaXfer4BperTxn,
               32'd3, 32'd8, 33'd3);
    check_size("fixed-1B", 1'b0, 1'b1, DmaXfer1BperTxn, 32'd16, 32'd8, 33'd1);
    check_size("fixed-2B", 1'b0, 1'b1, DmaXfer2BperTxn, 32'd16, 32'd8, 33'd2);
    check_size("fixed-4B", 1'b0, 1'b1, DmaXfer4BperTxn, 32'd16, 32'd8, 33'd4);
    check_size("fixed-short-final", 1'b0, 1'b1, DmaXfer4BperTxn, 32'd3, 32'd3, 33'd3);
    check_size("fixed-nonwrap-1B-sparse-envelope", 1'b0, 1'b0, DmaXfer1BperTxn,
               32'd16, 32'd8, 33'd9);
    check_size("fixed-nonwrap-2B-sparse-envelope", 1'b0, 1'b0, DmaXfer2BperTxn,
               32'd16, 32'd8, 33'd10);
    check_size("fixed-nonwrap-4B-partial-final-envelope", 1'b0, 1'b0, DmaXfer4BperTxn,
               32'd18, 32'd8, 33'd18);

    // Byte-enabled destination writes and inclusive memory limits.
    check_invalid("write-exact-inclusive-limit", 32'h0000_1000, 33'd16,
                  1'b1, 1'b0, DmaXfer1BperTxn, 1'b0, 1'b1, 1'b1,
                  32'h0000_1000, 32'h0000_100f, 1'b0);
    check_invalid("write-one-byte-under-base", 32'h0000_0fff, 33'd1,
                  1'b1, 1'b0, DmaXfer1BperTxn, 1'b0, 1'b1, 1'b1,
                  32'h0000_1000, 32'h0000_100f, 1'b1);
    check_invalid("write-one-byte-over-limit", 32'h0000_1000, 33'd17,
                  1'b1, 1'b0, DmaXfer1BperTxn, 1'b0, 1'b1, 1'b1,
                  32'h0000_1000, 32'h0000_100f, 1'b1);
    check_invalid("write-32bit-wrap", 32'hffff_fffc, 33'd8,
                  1'b1, 1'b0, DmaXfer4BperTxn, 1'b0, 1'b1, 1'b0,
                  32'h0, 32'hffff_ffff, 1'b1);
    check_invalid("fixed-write-does-not-check-total", 32'h0000_100c, 33'd4,
                  1'b0, 1'b1, DmaXfer4BperTxn, 1'b0, 1'b1, 1'b1,
                  32'h0000_1000, 32'h0000_100f, 1'b0);
    check_invalid("wrapped-write-does-not-check-later-chunks", 32'h0000_1000, 33'd8,
                  1'b1, 1'b1, DmaXfer4BperTxn, 1'b0, 1'b1, 1'b1,
                  32'h0000_1000, 32'h0000_1007, 1'b0);

    // TL-UL source reads fetch aligned complete words, including narrow and partial-final reads.
    check_invalid("read-2B-exact-inclusive-limit", 32'h0000_1000, 33'd16,
                  1'b1, 1'b0, DmaXfer2BperTxn, 1'b1, 1'b1, 1'b1,
                  32'h0000_1000, 32'h0000_100f, 1'b0);
    check_invalid("fixed-1B-read-full-word-contained", 32'h0000_1001, 33'd1,
                  1'b0, 1'b1, DmaXfer1BperTxn, 1'b1, 1'b1, 1'b1,
                  32'h0000_1000, 32'h0000_1003, 1'b0);
    check_invalid("fixed-1B-read-full-word-escapes", 32'h0000_1001, 33'd1,
                  1'b0, 1'b1, DmaXfer1BperTxn, 1'b1, 1'b1, 1'b1,
                  32'h0000_1001, 32'h0000_1001, 1'b1);
    check_invalid("partial-final-4B-read-exact-limit", 32'h0000_1008, 33'd5,
                  1'b1, 1'b0, DmaXfer4BperTxn, 1'b1, 1'b1, 1'b1,
                  32'h0000_1000, 32'h0000_100f, 1'b0);
    check_invalid("wrapped-2B-read-physical-word-limit", 32'h0000_1000, 33'd6,
                  1'b1, 1'b1, DmaXfer2BperTxn, 1'b1, 1'b1, 1'b1,
                  32'h0000_1000, 32'h0000_1007, 1'b0);
    check_invalid("wrapped-2B-read-logical-only-limit-rejected", 32'h0000_1000, 33'd6,
                  1'b1, 1'b1, DmaXfer2BperTxn, 1'b1, 1'b1, 1'b1,
                  32'h0000_1000, 32'h0000_1005, 1'b1);
    check_invalid("increment-read-32bit-wrap", 32'hffff_fffc, 33'd8,
                  1'b1, 1'b0, DmaXfer4BperTxn, 1'b1, 1'b1, 1'b0,
                  32'h0, 32'hffff_ffff, 1'b1);
    check_invalid("fixed-1B-read-at-address-space-end", 32'hffff_ffff, 33'd1,
                  1'b0, 1'b1, DmaXfer1BperTxn, 1'b1, 1'b1, 1'b0,
                  32'h0, 32'hffff_ffff, 1'b0);

    // Compose both helpers for the sparse fixed-within-chunk, non-wrapped mode.
    check_composed_footprint("fixed-nonwrap-write-exact-sparse-limit",
                             32'h0000_1000, 1'b0, 1'b0, DmaXfer1BperTxn,
                             32'd16, 32'd8, 1'b0,
                             32'h0000_1000, 32'h0000_1008, 33'd9, 1'b0);
    check_composed_footprint("fixed-nonwrap-write-one-byte-over",
                             32'h0000_1000, 1'b0, 1'b0, DmaXfer1BperTxn,
                             32'd16, 32'd8, 1'b0,
                             32'h0000_1000, 32'h0000_1007, 33'd9, 1'b1);
    check_composed_footprint("fixed-nonwrap-read-physical-exact-limit",
                             32'h0000_1000, 1'b0, 1'b0, DmaXfer2BperTxn,
                             32'd16, 32'd8, 1'b1,
                             32'h0000_1000, 32'h0000_100b, 33'd10, 1'b0);

    check_handshake_trigger_validates_before_clear();
    check_valid_handshake_clear_path();

    // Invalid configurations must transition to the error state without asserting any data-bus
    // request. Cover both address directions and both non-final chunk-alignment branches.
    check_rejected_setup_no_requests("destination-range-overflow-no-request",
                                     DmaXfer1BperTxn, 32'd17, 32'd8,
                                     SocControlAddr, OtInternalAddr,
                                     32'h0000_2000, 32'h0000_1000,
                                     1'b1, 1'b0, 1'b1, 1'b0,
                                     32'h0000_1000, 32'h0000_100f, DmaDstAddrErr);
    check_rejected_setup_no_requests("source-range-underflow-no-request",
                                     DmaXfer1BperTxn, 32'd1, 32'd1,
                                     OtInternalAddr, SocControlAddr,
                                     32'h0000_0fff, 32'h0000_2000,
                                     1'b1, 1'b0, 1'b1, 1'b0,
                                     32'h0000_1000, 32'h0000_100f, DmaSrcAddrErr);
    check_rejected_setup_no_requests("four-byte-nonfinal-chunk-no-request",
                                     DmaXfer4BperTxn, 32'd8, 32'd2,
                                     OtInternalAddr, SocControlAddr,
                                     32'h0000_1000, 32'h0000_2000,
                                     1'b1, 1'b0, 1'b1, 1'b0,
                                     32'h0000_0000, 32'hffff_ffff, DmaSizeErr);
    check_rejected_setup_no_requests("two-byte-nonfinal-chunk-no-request",
                                     DmaXfer2BperTxn, 32'd8, 32'd3,
                                     OtInternalAddr, SocControlAddr,
                                     32'h0000_1000, 32'h0000_2000,
                                     1'b1, 1'b0, 1'b1, 1'b0,
                                     32'h0000_0000, 32'hffff_ffff, DmaSizeErr);

    if (failures == 0) begin
      $display("DMA_FOOTPRINT_XSIM_PASS checks=%0d", checks);
      $finish;
    end
    $fatal(1, "DMA_FOOTPRINT_XSIM_FAIL checks=%0d failures=%0d", checks, failures);
  end
endmodule
