// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Directed checks for the inclusive DMA-enabled OT memory boundary. Invalid cases rely on the
// scoreboard's fatal check for any DMA source/destination transaction after configuration rejection.
class dma_mem_boundary_vseq extends dma_generic_vseq;
  `uvm_object_utils(dma_mem_boundary_vseq)
  `uvm_object_new

  localparam int unsigned NumBoundaryCases = 23;

  int unsigned case_idx;
  bit          expect_addr_error;
  int unsigned expected_error_bit;
  string       boundary_case_name;

  constraint iters_c {num_iters == 1;}
  constraint transactions_c {num_txns == NumBoundaryCases;}

  virtual function bit pick_if_config_valid();
    return 1'b0;
  endfunction

  virtual function bit pick_if_intr_driven();
    return 1'b0;
  endfunction

  virtual function void randomize_item(ref dma_seq_item dma_config);
    int unsigned selected_case = case_idx % NumBoundaryCases;

    dma_config.reset_config();
    dma_config.mem_range_valid = 1'b1;
    dma_config.mem_range_base = 32'h0000_1000;
    dma_config.mem_range_limit = 32'h0000_100f;
    dma_config.total_data_size = 32'd16;
    dma_config.chunk_data_size = 32'd8;
    dma_config.src_addr = 64'h0000_0000_0000_2000;
    dma_config.dst_addr = 64'h0000_0000_0000_1000;
    dma_config.src_asid = SocControlAddr;
    dma_config.dst_asid = OtInternalAddr;
    dma_config.src_addr_inc = 1'b1;
    dma_config.dst_addr_inc = 1'b1;
    dma_config.src_chunk_wrap = 1'b0;
    dma_config.dst_chunk_wrap = 1'b0;
    dma_config.per_transfer_width = DmaXfer1BperTxn;
    dma_config.opcode = OpcCopy;
    dma_config.handshake = 1'b0;
    dma_config.range_regwen = MuBi4True;
    dma_config.clear_intr_src = '0;
    dma_config.clear_intr_bus = '0;
    dma_config.handshake_intr_en = '0;
    dma_config.lsio_trigger_i = '0;
    dma_config.soc_system_src_base_addr = 64'h0000_0001_0000_0000;
    dma_config.soc_system_dst_base_addr = 64'h0000_0002_0000_0000;
    dma_config.intr_src_addr = new[dma_reg_pkg::NumIntClearSources];
    dma_config.intr_src_wr_val = new[dma_reg_pkg::NumIntClearSources];
    dma_config.sha2_digest = new[16];

    expect_addr_error = 1'b0;
    expected_error_bit = DmaDstAddrErr;

    unique case (selected_case)
      0: begin
        boundary_case_name = "increment-dst-1B-exact-limit";
      end
      1: begin
        boundary_case_name = "increment-src-2B-exact-limit";
        dma_config.src_addr = 64'h0000_0000_0000_1000;
        dma_config.dst_addr = 64'h0000_0000_0000_2000;
        dma_config.src_asid = OtInternalAddr;
        dma_config.dst_asid = SocControlAddr;
        dma_config.per_transfer_width = DmaXfer2BperTxn;
      end
      2: begin
        boundary_case_name = "increment-system-to-ot-4B-exact-limit";
        dma_config.src_addr = 64'h0000_0001_0000_2000;
        dma_config.src_asid = SocSystemAddr;
        dma_config.per_transfer_width = DmaXfer4BperTxn;
      end
      3: begin
        boundary_case_name = "src-1B-one-byte-under-base";
        dma_config.src_addr = 64'h0000_0000_0000_0fff;
        dma_config.dst_addr = 64'h0000_0000_0000_2000;
        dma_config.src_asid = OtInternalAddr;
        dma_config.dst_asid = SocControlAddr;
        dma_config.total_data_size = 32'd1;
        dma_config.chunk_data_size = 32'd1;
        expect_addr_error = 1'b1;
        expected_error_bit = DmaSrcAddrErr;
      end
      4: begin
        boundary_case_name = "dst-1B-one-byte-under-base";
        dma_config.dst_addr = 64'h0000_0000_0000_0fff;
        dma_config.total_data_size = 32'd1;
        dma_config.chunk_data_size = 32'd1;
        expect_addr_error = 1'b1;
      end
      5: begin
        boundary_case_name = "src-1B-one-byte-over-limit";
        dma_config.src_addr = 64'h0000_0000_0000_1000;
        dma_config.dst_addr = 64'h0000_0000_0000_2000;
        dma_config.src_asid = OtInternalAddr;
        dma_config.dst_asid = SocControlAddr;
        dma_config.total_data_size = 32'd17;
        dma_config.chunk_data_size = 32'd8;
        expect_addr_error = 1'b1;
        expected_error_bit = DmaSrcAddrErr;
      end
      6: begin
        boundary_case_name = "dst-4B-one-transaction-over-limit";
        dma_config.per_transfer_width = DmaXfer4BperTxn;
        dma_config.total_data_size = 32'd20;
        expect_addr_error = 1'b1;
      end
      7: begin
        boundary_case_name = "dst-4B-32bit-wrap";
        dma_config.mem_range_base = 32'hffff_fffc;
        dma_config.mem_range_limit = 32'hffff_ffff;
        dma_config.dst_addr = 64'h0000_0000_ffff_fffc;
        dma_config.total_data_size = 32'd8;
        dma_config.chunk_data_size = 32'd8;
        dma_config.per_transfer_width = DmaXfer4BperTxn;
        expect_addr_error = 1'b1;
      end
      8: begin
        boundary_case_name = "src-2B-32bit-wrap-to-system";
        dma_config.mem_range_base = 32'hffff_fffe;
        dma_config.mem_range_limit = 32'hffff_ffff;
        dma_config.src_addr = 64'h0000_0000_ffff_fffe;
        dma_config.dst_addr = 64'h0000_0002_0000_2000;
        dma_config.src_asid = OtInternalAddr;
        dma_config.dst_asid = SocSystemAddr;
        dma_config.total_data_size = 32'd4;
        dma_config.chunk_data_size = 32'd4;
        dma_config.per_transfer_width = DmaXfer2BperTxn;
        expect_addr_error = 1'b1;
        expected_error_bit = DmaSrcAddrErr;
      end
      9: begin
        boundary_case_name = "fixed-dst-1B-at-limit";
        dma_config.dst_addr = 64'h0000_0000_0000_100f;
        dma_config.dst_addr_inc = 1'b0;
        dma_config.dst_chunk_wrap = 1'b1;
      end
      10: begin
        boundary_case_name = "fixed-src-2B-ending-at-limit";
        dma_config.src_addr = 64'h0000_0000_0000_100e;
        dma_config.dst_addr = 64'h0000_0000_0000_2000;
        dma_config.src_asid = OtInternalAddr;
        dma_config.dst_asid = SocControlAddr;
        dma_config.src_addr_inc = 1'b0;
        dma_config.src_chunk_wrap = 1'b1;
        dma_config.per_transfer_width = DmaXfer2BperTxn;
      end
      11: begin
        boundary_case_name = "fixed-dst-4B-ending-at-limit";
        dma_config.dst_addr = 64'h0000_0000_0000_100c;
        dma_config.dst_addr_inc = 1'b0;
        dma_config.dst_chunk_wrap = 1'b1;
        dma_config.per_transfer_width = DmaXfer4BperTxn;
      end
      12: begin
        boundary_case_name = "fixed-dst-2B-one-byte-over-limit";
        dma_config.mem_range_limit = 32'h0000_100e;
        dma_config.dst_addr = 64'h0000_0000_0000_100e;
        dma_config.dst_addr_inc = 1'b0;
        dma_config.dst_chunk_wrap = 1'b1;
        dma_config.per_transfer_width = DmaXfer2BperTxn;
        expect_addr_error = 1'b1;
      end
      13: begin
        boundary_case_name = "chunk-wrap-src-1B-exact-limit";
        dma_config.mem_range_limit = 32'h0000_1003;
        dma_config.src_addr = 64'h0000_0000_0000_1000;
        dma_config.dst_addr = 64'h0000_0000_0000_2000;
        dma_config.src_asid = OtInternalAddr;
        dma_config.dst_asid = SocControlAddr;
        dma_config.src_chunk_wrap = 1'b1;
        dma_config.total_data_size = 32'd12;
        dma_config.chunk_data_size = 32'd4;
      end
      14: begin
        boundary_case_name = "chunk-wrap-dst-4B-exact-limit";
        dma_config.mem_range_limit = 32'h0000_1007;
        dma_config.dst_chunk_wrap = 1'b1;
        dma_config.per_transfer_width = DmaXfer4BperTxn;
      end
      15: begin
        boundary_case_name = "chunk-wrap-dst-2B-one-byte-over-limit";
        dma_config.mem_range_limit = 32'h0000_1006;
        dma_config.dst_chunk_wrap = 1'b1;
        dma_config.per_transfer_width = DmaXfer2BperTxn;
        expect_addr_error = 1'b1;
      end
      16: begin
        boundary_case_name = "nonwrap-multichunk-src-2B-exact-limit";
        dma_config.src_addr = 64'h0000_0000_0000_1000;
        dma_config.dst_addr = 64'h0000_0000_0000_2000;
        dma_config.src_asid = OtInternalAddr;
        dma_config.dst_asid = SocControlAddr;
        dma_config.chunk_data_size = 32'd4;
        dma_config.per_transfer_width = DmaXfer2BperTxn;
      end
      17: begin
        boundary_case_name = "nonwrap-multichunk-dst-4B-one-byte-over-limit";
        dma_config.mem_range_limit = 32'h0000_100e;
        dma_config.dst_chunk_wrap = 1'b0;
        dma_config.chunk_data_size = 32'd8;
        dma_config.per_transfer_width = DmaXfer4BperTxn;
        expect_addr_error = 1'b1;
      end
      18: begin
        boundary_case_name = "fixed-src-1B-full-word-escapes-narrow-range";
        dma_config.mem_range_base = 32'h0000_1001;
        dma_config.mem_range_limit = 32'h0000_1001;
        dma_config.src_addr = 64'h0000_0000_0000_1001;
        dma_config.dst_addr = 64'h0000_0000_0000_2000;
        dma_config.src_asid = OtInternalAddr;
        dma_config.dst_asid = SocControlAddr;
        dma_config.src_addr_inc = 1'b0;
        dma_config.src_chunk_wrap = 1'b1;
        dma_config.total_data_size = 32'd1;
        dma_config.chunk_data_size = 32'd1;
        expect_addr_error = 1'b1;
        expected_error_bit = DmaSrcAddrErr;
      end
      19: begin
        boundary_case_name = "increment-ctn-src-4B-32bit-wrap";
        dma_config.src_addr = 64'h0000_0000_ffff_fffc;
        dma_config.src_asid = SocControlAddr;
        dma_config.total_data_size = 32'd8;
        dma_config.chunk_data_size = 32'd8;
        dma_config.per_transfer_width = DmaXfer4BperTxn;
        expect_addr_error = 1'b1;
        expected_error_bit = DmaSrcAddrErr;
      end
      20: begin
        boundary_case_name = "increment-ctn-dst-4B-32bit-wrap";
        dma_config.src_addr = 64'h0000_0000_0000_1000;
        dma_config.dst_addr = 64'h0000_0000_ffff_fffc;
        dma_config.src_asid = OtInternalAddr;
        dma_config.dst_asid = SocControlAddr;
        dma_config.total_data_size = 32'd8;
        dma_config.chunk_data_size = 32'd8;
        dma_config.per_transfer_width = DmaXfer4BperTxn;
        expect_addr_error = 1'b1;
        expected_error_bit = DmaDstAddrErr;
      end
      21: begin
        boundary_case_name = "increment-dst-2B-partial-final-exact-limit";
        dma_config.mem_range_limit = 32'h0000_100e;
        dma_config.dst_addr = 64'h0000_0000_0000_100c;
        dma_config.total_data_size = 32'd3;
        dma_config.chunk_data_size = 32'd3;
        dma_config.per_transfer_width = DmaXfer2BperTxn;
      end
      22: begin
        boundary_case_name = "increment-src-4B-partial-final-full-word-exact-limit";
        dma_config.src_addr = 64'h0000_0000_0000_1008;
        dma_config.dst_addr = 64'h0000_0000_0000_2000;
        dma_config.src_asid = OtInternalAddr;
        dma_config.dst_asid = SocControlAddr;
        dma_config.total_data_size = 32'd5;
        dma_config.chunk_data_size = 32'd5;
        dma_config.per_transfer_width = DmaXfer4BperTxn;
      end
      default: `uvm_fatal(`gfn, $sformatf("Invalid boundary case index %0d", selected_case))
    endcase

    dma_config.is_valid_config = dma_config.check_config(boundary_case_name);
    `DV_CHECK_EQ(dma_config.is_valid_config, !expect_addr_error, $sformatf(
                 "Model classification mismatch for %s", boundary_case_name))
    `uvm_info(`gfn, $sformatf(
              "Configured boundary case %0d/%0d: %s",
              selected_case + 1,
              NumBoundaryCases,
              boundary_case_name
              ), UVM_LOW)
    case_idx++;
  endfunction

  virtual task ending_txn(int unsigned txn, int unsigned num_txns, ref dma_seq_item dma_config,
                          status_t status);
    if (expect_addr_error) begin
      bit [31:0] error_code;
      `DV_CHECK(status[StatusError], $sformatf("%s did not report an error", boundary_case_name))
      `DV_CHECK(!status[StatusDone], $sformatf("%s unexpectedly completed", boundary_case_name))
      csr_rd(ral.error_code, error_code);
      `DV_CHECK(error_code[expected_error_bit],
                $sformatf("%s did not set expected error bit %0d (ERROR_CODE=0x%0x)",
                          boundary_case_name, expected_error_bit, error_code))
    end else begin
      `DV_CHECK(status[StatusDone], $sformatf("%s did not complete successfully", boundary_case_name
                ))
      `DV_CHECK(!status[StatusError], $sformatf(
                "%s unexpectedly reported an error", boundary_case_name))
    end
  endtask

endclass
