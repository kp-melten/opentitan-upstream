# M7 Implementation Checkpoint

Generated UTC: 2026-07-16T20:36:07Z
Generated local: 2026-07-16T15:36:07-05:00 CDT
Posture: implementation checkpoint; no claim advancement

## Milestone delta

- M4 complete: a meaningful RTL/DV boundary increment exists and is locally
  exercised.
- M5 complete: centralized physical-footprint validation, the 44-case directed
  sequence, model/scoreboard agreement, no-data-request checks, testplan/config
  entries, and documentation form one reviewable candidate.
- M6 complete: fresh DMA lint, DV lint, and Xilinx evidence are recorded.
- M7 complete: this local checkpoint is recorded. M8 is next. M1-M3 remain
  pending for promotion authority and sign-off.

## Design and work-product delta

- Added centralized 33-bit footprint sizing and validation in `dma.sv` for all
  `{increment,wrap}` combinations and transfer widths.
- Included aligned full-word physical source reads and byte-enabled destination
  writes, applicable 32-bit wrap rejection, and complete non-wrapped
  envelopes.
- Rejected transfer-width-misaligned non-final chunks before a data request.
- Added `dma_mem_boundary_vseq`, inclusive randomized model logic, scoreboard
  lane checking, and fatal checks for source/destination data requests after
  invalid configuration classification.
- Registered the test in DMA simulation/testplan collateral and updated DMA
  documentation.
- Added a behavior-preserving `prim_diff_decode` counter-width cleanup required
  for the selected DMA Verilator target.

## Evidence delta

- `checks/m6/rtl-verilator-results.hjson`: zero flow errors and zero lint
  warnings/errors; the wrapper reports only the known Edalize deprecation
  warning.
- `checks/m6/direct-make-lint.log`: generated DMA `lint-only` target exited 0.
- `checks/m6/dv-verible-results.hjson`: clean DMA DV style lint.
- `checks/m6/xsim-tb.log`: `DMA_FOOTPRINT_XSIM_PASS checks=44`.
- `checks/m6/uvm-xsim-build.log`: full UVM XSim elaboration attempted and
  blocked by common `uvm_hdl_release` signature incompatibility.
- `verifier/m6/result.md`: independent source review found no high-severity
  blocker for the provisional no-data-request boundary and identified the
  interrupt-clear ambiguity.

## Branch sync

- Branch:
  `campaign/dma-memory-protection-closure-04908ed9c14c`.
- Base: `58f8fdd5396817b775d2c69af9a6322ac7a84e5a`.
- This checkpoint is local and not pushed; upstream tracking is intentionally
  pending user authorization.

## Claim boundary and remaining work

Supported checkpoint statement:

> The candidate implements the reviewed overflow-safe DMA memory-footprint
> check, the generated DMA Verilator lint target exits successfully, DMA DV
> lint is clean, and the focused XSim helper passes.

Remaining:

- Clarify whether invalid handshake configurations must suppress configured
  interrupt-clear writes as well as source/destination data requests.
- Run `dma_mem_boundary` on a supported full UVM simulator.
- Obtain human silicon-architect and DV-owner sign-offs before promotion.
- Assess variable-divider synthesis/QoR if a physical implementation claim is
  later requested.

Non-claims: no full regression, coverage, formal security proof, synthesis,
timing, integration, silicon, or promotion claim.

Next action: resolve the interrupt-clear boundary, then run the directed UVM
sequence with a supported simulator and obtain independent behavioral review.
