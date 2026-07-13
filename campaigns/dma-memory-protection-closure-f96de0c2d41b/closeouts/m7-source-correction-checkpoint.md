# Campaign Step Closeout

Generated: 2026-07-13T20:21:33Z
Generated UTC: 2026-07-13T20:21:33Z
Generated local: 2026-07-13T15:21:33-05:00 CDT
Campaign: "dma-memory-protection-closure-f96de0c2d41b"
Support profile ID: "opentitan-dma"
Workspace: "/home/k/melten-dev/opentitan-upstream"
Branch: "campaign/dma-memory-protection-closure-f96de0c2d41b"
HEAD: "437dbac2b0de745ce6fb5116d4d0623f61f23535"
Milestone: "M7"
Claim posture: "implementation_checkpoint"
Slice ID: "m7-source-correction"
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

Corrected candidate C1 now validates physical aligned full-word TL-UL source reads, byte-enabled destination writes, and 32-bit OT/CTN wrap; extended the directed sequence to 23 cases and recorded focused source review.

## Closeout Delta

- Which milestone did this advance, block, or leave unchanged? M7
- Design/work-product/evidence notes: Added committed-candidate DV Verible pass, base-blocked Verilator result, unavailable Xcelium report, and independent focused source review.
- Did accepted objective, DV plan, milestone, requirement, or claim-boundary state change or need review? M7 remains pending: the corrected source is reviewable, but lint-target pass, directed behavioral evidence, and required sign-offs are unresolved.
- What is the next milestone-directed action? Obtain user/controller direction on the unrelated prim_diff_decode lint blocker, then run a zero-exit DMA Verilator target and dma_mem_boundary with Xcelium before any claim-bearing closeout.

## Claim Boundary / Advancement

Implementation checkpoint only: source review supports the corrected footprint structure and model alignment; no behavioral, lint-target-pass, no-request dynamic, or promotion claim.

## Verifier Status

Independent focused source re-review found both prior high-severity findings corrected with no new RTL/model mismatch in scope; promotion remains blocked on dynamic evidence and sign-off.

## Evidence Inputs

- "campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m7/check-summary.md" (file; 3142 bytes)
- "campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m7/dv-verible-results.hjson" (file; 108 bytes)
- "campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m7/rtl-verilator-results.hjson" (file; 4232 bytes)
- "campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m7/directed-xcelium-report.json" (file; 4014 bytes)
- "campaigns/dma-memory-protection-closure-f96de0c2d41b/verifier/m7/result.md" (file; 2053 bytes)

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
