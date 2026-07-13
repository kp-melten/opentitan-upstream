# Campaign Step Closeout

Generated: 2026-07-13T18:27:20Z
Generated UTC: 2026-07-13T18:27:20Z
Generated local: 2026-07-13T13:27:20-05:00 CDT
Campaign: "dma-memory-protection-closure-f96de0c2d41b"
Support profile ID: "opentitan-dma"
Workspace: "/home/k/melten-dev/opentitan-upstream"
Branch: "campaign/dma-memory-protection-closure-f96de0c2d41b"
HEAD: "99f268db3a0c85146041e736e6b06651369fffda"
Milestone: "M6"
Claim posture: "implementation_checkpoint"
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

Advanced M4-M6: committed centralized 33-bit inclusive DMA footprint validation, aligned sequence-model and scoreboard semantics, an 18-case directed boundary sequence, transaction-free invalid-configuration checking, and testplan/simulation integration. DV Verible lint passed; the DMA Verilator target remains blocked by the same prim_diff_decode.sv warning on the clean base; Xcelium simulation remains pending because xrun is unavailable.

## Closeout Delta

- Which milestone did this advance, block, or leave unchanged? M6
- Design/work-product/evidence notes: Added the RTL-derived footprint table, candidate and baseline Verilator results, passing DV Verible result, unavailable Xcelium report, and bounded M6 check summary.
- Did accepted objective, DV plan, milestone, requirement, or claim-boundary state change or need review? M4-M6 are complete as implementation checkpoints. M1-M3 promotion sign-offs and M7 independent review remain pending. The Verilator-pass and directed-simulation-pass hard gates are explicitly not met.
- What is the next milestone-directed action? Have an independent RTL/DV reviewer inspect candidate C0, resolve or policy-waive the base-reproducible Verilator warning, and run dma_mem_boundary with Xcelium before any claim-bearing or promotion closeout.

## Claim Boundary / Advancement

No campaign claim advancement. Candidate C0 is an implementation checkpoint bounded to the committed source and recorded static/tool attempts.

## Verifier Status

No independent verifier review requested or completed in this run.

## Evidence Inputs

- "campaigns/dma-memory-protection-closure-f96de0c2d41b/artifacts/m4/footprint-table.md" (file; 1663 bytes)
- "campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m6/check-summary.md" (file; 2994 bytes)
- "campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m6/rtl-verilator-candidate-results.hjson" (file; 4381 bytes)
- "campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m6/rtl-verilator-baseline-results.hjson" (file; 4380 bytes)
- "campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m6/dv-verible-results.hjson" (file; 108 bytes)
- "campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m6/directed-xcelium-report.json" (file; 4813 bytes)

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
