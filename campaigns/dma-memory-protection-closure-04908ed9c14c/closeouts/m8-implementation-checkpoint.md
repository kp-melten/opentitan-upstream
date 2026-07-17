# M8 Implementation Checkpoint

Generated UTC: 2026-07-17T02:16:25Z
Generated local: 2026-07-16T21:16:25-05:00 CDT
Posture: implementation checkpoint; no promotion

## Milestone delta

- M8 advanced but remains pending. The strict all-request boundary is now
  implemented and independently accepted with exact-revision focused evidence;
  full directed UVM remains required for M8 exit.
- M1-M3 remain pending because the human silicon-architect and DV-owner
  promotion sign-offs are not recorded.

## Design and work-product delta

- Resolved the interrupt-clear ambiguity using the literal “before any bus
  request” boundary.
- Hardware-handshake triggers now enter `DmaAddrSetup` before a configured
  interrupt-clear write. Valid configurations clear the interrupt and return
  through setup validation before issuing source or destination traffic.
- The scoreboard now rejects any source, destination, or interrupt-clear
  transaction after invalid configuration classification.
- Expanded `dma_mem_boundary_vseq` from 44 to 45 cases with an invalid
  handshake-clear destination-under-base case.
- Expanded the XSim helper to 49 checks, including invalid trigger sequencing
  and the valid clear-then-transfer path. Pinned primitive core selection makes
  its FuseSoC setup deterministic.
- Corrected the programmer guide to list all four `{increment, wrap}` modes.

Implementation commit:
`c9619cb7610e9554eae1b812a5fadd7fd9fa32ac`.

## Evidence delta

- Exact-candidate generated Verilator `lint-only`: exit 0.
- DMA DV Verible lint: exit 0, no warnings or errors.
- DMA DVSim/Verilator results: no lint warnings/errors; wrapper exit 1 only for
  the Edalize legacy-backend deprecation flow warning.
- Vivado Simulator 2025.2.1 focused helper: pass marker
  `DMA_FOOTPRINT_XSIM_PASS checks=49`.
- Commands, normalized tool metadata, exact files, and digests are recorded in
  `checks/m8/check-summary.md`.

## Verification disposition

- The earlier independent review identified the interrupt-clear prevalidation
  gap and otherwise found the complete footprint formulas consistent with RTL
  request traces over its enumerated mode/width/size surface.
- The separate verification agent accepted candidate C2 for the requested
  non-promotion implementation checkpoint, found the prior strict-request
  blocker closed, and found no remaining source-level footprint correctness
  blocker. The exact disposition is recorded in `verifier/m8/result.md`.
- The full 45-case UVM sequence remains pending: XSim's installed UVM library
  is incompatible with common OpenTitan one-argument `uvm_hdl_release` calls,
  and Xcelium, VCS, and Questa executables are absent.

## Accepted state and branch state

- No objective, DV plan, requirement, or promotion state is human-accepted by
  this checkpoint. The ledgers now record the stricter source boundary and its
  evidence without advancing the claim beyond the user's requested wording.
- The campaign branch was published and configured to track
  `origin/campaign/dma-memory-protection-closure-04908ed9c14c` at recording
  revision `bb74f9589e337c39ee3ccb0ddf64ccd7912a1ae5`. The verifier-result commit
  is the final closeout delta and must be pushed before the campaign is handed
  off.

## Non-claims and next action

- No full DMA regression or coverage closure.
- No formal security proof.
- No synthesis/QoR, top-level integration, timing, or silicon claim.
- No promotion claim until independent review and required sign-offs.
- The unavailable full-UVM run remains pending, not implicitly passing.

Next action: run `dma_mem_boundary` on a supported UVM simulator when one is
available, then obtain the outstanding human/DV sign-offs before any promotion
claim.
