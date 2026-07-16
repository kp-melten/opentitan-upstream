# M6 Independent Verification Result

Date: 2026-07-16
Review mode: independent read-only source and DV-plan review
Verdict: implementation candidate is coherent; promotion remains blocked

## Accepted source conclusions

- The four `{increment,wrap}` combinations have distinct exact envelopes.
- Fixed/non-wrapped addressing is fixed within a chunk and advances by the
  chunk size between chunks.
- OT source reads must validate aligned full-word physical Gets; destination
  writes validate enabled lanes.
- Applicable endpoint arithmetic is widened and rejects bit-32 carry.
- Partial non-final chunks are rejected before a data request because the RTL
  byte counters advance by a complete transfer width.
- The sequence/model/scoreboard source covers the principal mode, width,
  direction, edge, wrap, and no-data-request surfaces.

No high-severity source-level correctness blocker was identified for the
provisional source/destination-data-request claim.

## Required boundary clarification

Handshake interrupt-clear writes occur before `DmaAddrSetup` validation in the
existing architecture. The current candidate and scoreboard exclude those
writes from the no-request claim.

If the controller intends “no bus requests” literally, validation must precede
`DmaClearIntrSrc`, and a handshake case with an active trigger plus nonzero
`clear_intr_src` must observe zero external requests. Until clarified, the
supported boundary is only “no source-read or destination-write data request.”

## Remaining evidence gaps

- Full `dma_mem_boundary` UVM execution is pending.
- Focused XSim does not clock a complete programmed multi-chunk transfer or
  execute the scoreboard bus monitors.
- Variable-division synthesis/QoR is unassessed.
- Initial human silicon-architect and DV-owner sign-offs are pending.
- No regression, coverage, formal, synthesis, integration, promotion, or
  silicon claim is supported.
