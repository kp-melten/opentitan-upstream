# M11 Independent Source Review Result

Date: 2026-07-15
Candidate: dirty working candidate based on `62c937ed152414567e0e1b555f8ff3c0502e3dae`
Review mode: independent read-only source and focused-evidence review
Verdict: no source-level correctness blocker; implementation checkpoint only

## Accepted source conclusions

- The fixed-within-chunk, non-wrapped envelope matches the RTL chunk address
  advancement and does not include bytes that are never accessed.
- Per-side remaining-size wiring applies only to fixed non-wrapped endpoints.
- Four-byte width with a two-byte non-final chunk and two-byte width with an odd
  non-final chunk are rejected in `DmaAddrSetup` before transfer requests.
- The UVM model and scoreboard prediction agree with the revised RTL semantics.
- The 44-case sequence includes the sparse fixed non-wrapped cases across widths
  and restricted directions, both required chunk-size errors, and incrementing
  multi-chunk cases.

No high-severity RTL/DV source finding remains.

## Evidence disposition

- DMA Verilator generated results contain zero flow errors and zero lint
  warnings/errors; direct generated `make lint-only` exits 0. The DVSim wrapper
  still returns nonzero for the known Edalize deprecation flow warning.
- DMA DV Verible lint passes with zero diagnostics.
- The XSim harness passes 44 helper/composition and structural setup checks.
- Raw lint and XSim logs plus SHA-256 digests are retained under `checks/m11/`.

## Remaining verification gaps

- The full `dma_mem_boundary` UVM sequence was not run because Xcelium is absent.
- XSim forces `DmaAddrSetup` at `transfer_byte_q=0`; it does not clock a programmed
  multi-chunk transfer, execute scoreboard runtime behavior, or provide bus-monitor
  no-request evidence.
- Synthesis QoR of variable division has not been assessed.
- Full regression, coverage, formal, integration, synthesis/timing, promotion,
  and silicon claims remain excluded.

## Claim assessment

The candidate supports the bounded implementation-checkpoint claim that it
implements the independently reviewed overflow-safe footprint logic and passes
the recorded static and focused structural checks. It does not support promotion
or full behavioral closure.
