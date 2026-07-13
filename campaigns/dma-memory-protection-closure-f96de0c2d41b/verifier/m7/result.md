# M7 Independent Source Review Result

Date: 2026-07-13
Candidate: `aaf13e1aa2c36681596fc2393acdebfda7b2db29`
Review mode: evidence-review, source-level only
Verdict: accepted for narrowed source-alignment scope; promotion blocked

## Findings resolved

- Source footprint validation now includes aligned full-word TL-UL Get requests, including
  bytes before or after a narrow logical transfer.
- Low-32-bit footprint wrap is rejected for both OT and CTN source and destination sides,
  with direction-appropriate address errors before `DmaSendRead`.
- The UVM model and constraint-side valid generation mirror the corrected physical source
  and logical destination footprints.
- Directed cases cover the prior narrow-read leak, CTN source/destination wrap, and
  partial-final 2B/4B transfers. The existing matrix continues to cover fixed,
  incrementing, chunk-wrapped, non-wrapped, width, and restricted-direction cases.

No new RTL/model mismatch was found in the focused corrected scope.

## Evidence disposition

- DMA DV Verible lint: passed on the committed candidate.
- DMA Verilator target: nonzero because of the recorded base-reproducible
  `prim_diff_decode.sv:162` width diagnostic; the hard pass gate is not satisfied.
- Directed simulation: not compiled or run because Xcelium is unavailable.
- Fail-before-request behavior is structurally reviewable and scoreboard-checked, but has no
  dynamic assertion result without simulation.

## Required next actions

1. Resolve or policy-waive the baseline Verilator diagnostic and obtain a passing target.
2. Compile and run `dma_mem_boundary` on an accepted supported simulator.
3. Complete silicon-architect and DV-owner sign-offs before any promotion claim.

## Non-claims

- No behavioral pass or no-request dynamic proof.
- No full regression or coverage closure.
- No formal security proof.
- No top-level integration, synthesis, timing, silicon, or promotion claim.

This independent review record informs campaign claim boundaries; it is not controller or
human promotion authority.
