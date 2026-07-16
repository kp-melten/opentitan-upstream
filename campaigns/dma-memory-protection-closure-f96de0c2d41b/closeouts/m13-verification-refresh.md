# Campaign Step Closeout

Generated: 2026-07-16T17:33:43Z
Generated UTC: 2026-07-16T17:33:43Z
Generated local: 2026-07-16T12:33:43-05:00 CDT
Campaign: "dma-memory-protection-closure-f96de0c2d41b"
Support profile ID: "opentitan-dma"
Workspace: "/home/k/melten-dev/opentitan-upstream"
Branch: "campaign/dma-memory-protection-closure-f96de0c2d41b"
HEAD: "598df80aec7bd0fafd634fb3d1d803362a47e287"
Milestone: "M7"
Claim posture: "implementation_checkpoint"
Slice ID: "m13-verification-refresh"
Current next milestone before closeout: "M7"
Branch sync before closeout: "synced"
Campaign check status before closeout: "warning"
Artifact roots status: "ok"
Artifact root: "campaigns/dma-memory-protection-closure-f96de0c2d41b"
Artifact surface "artifacts": "campaigns/dma-memory-protection-closure-f96de0c2d41b/artifacts"
Artifact surface "checks": "campaigns/dma-memory-protection-closure-f96de0c2d41b/checks"
Artifact surface "evidence": "campaigns/dma-memory-protection-closure-f96de0c2d41b/evidence"
Artifact surface "tool-runs": "campaigns/dma-memory-protection-closure-f96de0c2d41b/tool-runs"
Artifact surface "verifier": "campaigns/dma-memory-protection-closure-f96de0c2d41b/verifier"

## Summary

Refreshed C4 verification on the committed campaign head: DMA Verible is clean, generated DMA Verilator lint has zero diagnostics and direct lint-only exits 0, the 44-check XSim footprint/no-request harness passes, and the full UVM XSim build is explicitly blocked by the vendor uvm_hdl_release signature incompatibility; no RTL or DV source change was required.

## Closeout Delta

- Which milestone did this advance, block, or leave unchanged? M7
- Design/work-product/evidence notes: Added tracked M13 static-check logs/results, focused XSim output, full-UVM XSim compatibility log, digest index, and corresponding candidate/decision ledger updates.
- Did accepted objective, DV plan, milestone, requirement, or claim-boundary state change or need review? M7 remains pending. The XSim probe converts the full-UVM simulator gap from an untested assumption into a source-backed compatibility blocker; supported-simulator UVM execution and variable-division synthesis/QoR assessment remain the next verification work.
- What is the next milestone-directed action? Run dma_mem_boundary on a supported UVM simulator, obtain clocked multi-chunk and bus-monitor no-request evidence, assess the fixed-nonwrapped variable division in synthesis/QoR, then obtain architect and DV-owner sign-offs before promotion review.

## Claim Boundary / Advancement

Implementation checkpoint only: the existing C4 candidate passes the recorded static and focused XSim checks. No full UVM, clocked multi-chunk scoreboard, full bus-monitor no-request, regression, coverage, formal, synthesis/QoR, integration, timing, silicon, or promotion claim.

## Verifier Status

No new promotion review requested. The prior M11 independent source review remains applicable; M13 is a main-agent evidence refresh and simulator-compatibility probe.

## Evidence Inputs

- "campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m13/check-summary.md" (file; 4076 bytes)
- "campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m13/rtl-verilator-results.hjson" (file; 352 bytes)
- "campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m13/direct-make-lint.txt" (file; 552 bytes)
- "campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m13/dv-verible-results.hjson" (file; 107 bytes)
- "campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m13/xsim-tb-log.txt" (file; 1818 bytes)
- "campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m13/uvm-xsim-build.txt" (file; 35492 bytes)

## Campaign Non-Claims

- "No full DMA regression or coverage closure."
- "No formal security proof."
- "No top-level integration, synthesis, timing, or silicon claim."
- "No promotion claim until independently reviewed and the initial packet is signed."
- "Simulator-unavailable tests remain pending, not implicitly passing."

## Closeout Non-Claims

- "Campaign closeout generation does not verify design correctness or accept design claims."
- "Implementation-checkpoint closeouts do not require verifier review and do not advance claim scope."
- "Claim-bearing and promotion closeouts require explicit claim boundary and verifier status before claim advancement."
- "Campaign closeout records milestone-directed delta state for review; it does not update milestone ledgers automatically."
- "Draft/pre-commit closeout mode records dirty or new evidence provenance when explicitly enabled; it does not accept those paths as clean or sufficient evidence."

## Campaign Hygiene Before Closeout

- failures: none
- warning: "initial_packet_discovery_exception_not_promotion_signoff:campaigns/dma-memory-protection-closure-f96de0c2d41b/initial-packet.md"

## Required Follow-Up

- Review this closeout against the campaign objective, DV/evidence plan, and milestone ledger.
- Update `milestones.md`, `milestones.json`, `decision-log.md`, or other campaign ledgers only when this closeout changes accepted state.
- Commit this closeout and any ledger updates on the campaign branch.
- Push the campaign branch, then run the following for final hygiene:

  ```
  swb campaign check --workspace /home/k/melten-dev/opentitan-upstream --support-profile-id opentitan-dma --campaign-id dma-memory-protection-closure-f96de0c2d41b --fetch --require-clean
  ```
  Omit `--fetch` only when network access or GitHub auth is unavailable.
