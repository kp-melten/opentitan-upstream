# M8 Lint-Resolution Implementation Checkpoint

Generated local: 2026-07-14 America/Chicago
Posture: implementation_checkpoint
Milestone: M7 remains pending

## Delta

Resolved the lint-width blockers that prevented the DMA Verilator lint surface
from reaching a zero-diagnostic state:

- `hw/ip/prim/rtl/prim_diff_decode.sv` now uses an explicit skew-counter width,
  explicit parameter extension, and a typed increment/comparison.
- `hw/ip/dma/rtl/dma.sv` now uses explicit width extension for the SHA
  message-length shift and explicit DMA error-index casts for `next_error`.

The DMA memory-footprint RTL/DV implementation from C1 is otherwise unchanged.

## Evidence changed

- Added `checks/m8/check-summary.md`.
- Added raw M8 DMA Verilator/DVSim output under `checks/m8/dma-verilator/`.
- Added direct generated `make lint-only` output under
  `checks/m8/direct-make-lint/`.
- Added directed Xcelium probe/output under `checks/m8/directed-xcelium/`.

## Result

The generated DMA Verilator lint report has zero flow errors, lint warnings,
and lint errors, and the generated `make lint-only` target exits 0.

The DVSim wrapper still exits nonzero because it treats the Edalize backend
deprecation as a flow warning. Directed Xcelium simulation remains pending
because `xrun` is unavailable.

## Claim boundary

Implementation-checkpoint only: the candidate implements the DMA footprint
closure work and clears the local generated Verilator lint diagnostics.

No behavioral simulation pass, no-request dynamic proof, full regression,
coverage closure, formal proof, integration, backend, silicon, or promotion
claim is made.

## Next action

Run `dma_mem_boundary` on an environment with Xcelium or another accepted
supported simulator, then obtain required silicon-architect/DV-owner sign-off
and independent promotion review if a stronger claim is desired.
