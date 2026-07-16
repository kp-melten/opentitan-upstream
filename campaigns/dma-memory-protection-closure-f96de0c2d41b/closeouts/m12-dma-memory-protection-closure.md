# Campaign Step Closeout

Generated: 2026-07-16T04:48:44Z
Generated UTC: 2026-07-16T04:48:44Z
Generated local: 2026-07-15T23:48:44-05:00 CDT
Campaign: "dma-memory-protection-closure-f96de0c2d41b"
Support profile ID: "opentitan-dma"
Workspace: "/home/k/melten-dev/opentitan-upstream"
Branch: "campaign/dma-memory-protection-closure-f96de0c2d41b"
HEAD: "24418e9a67ddc9264c519b690b2fb97ada47e01a"
Milestone: "M7"
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

C4 implements exact overflow-safe DMA memory footprints for all addressing combinations, aligns RTL and DV, adds the 44-case directed UVM sequence and focused XSim structural check, and passes the recorded clean-candidate static and XSim checks; M7 promotion verification remains pending.

## Closeout Delta

- Which milestone did this advance, block, or leave unchanged? M7
- Design/work-product/evidence notes: Added raw and summarized M11/M12 Verilator, Verible, and XSim evidence; independent M11 source review; C4 ledger entry; exact fixed-nonwrapped footprint derivation; campaign-local XSim runner and testbench.
- Did accepted objective, DV plan, milestone, requirement, or claim-boundary state change or need review? M5 and M6 deliverables remain complete at implementation-checkpoint scope. M7 remains pending for supported UVM execution, broader verification, and required human sign-offs.
- What is the next milestone-directed action? Run dma_mem_boundary on a supported UVM simulator, obtain bus-monitor-level no-request and clocked multi-chunk evidence, assess division synthesis QoR, then obtain architect/DV-owner sign-offs before promotion review.

## Claim Boundary / Advancement

Implementation checkpoint only: C4 implements the reviewed footprint closure and passes recorded static/focused checks. No full UVM, clocked multi-chunk scoreboard, bus-monitor no-request, regression, coverage, formal, synthesis/QoR, integration, timing, silicon, or promotion claim.

## Verifier Status

Independent read-only review found no source-level correctness blocker and accepted the bounded implementation-checkpoint claim after raw evidence retention and clean-candidate replay; full behavioral and promotion gaps remain.

## Evidence Inputs

- "campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m12/check-summary.md" (file; 2241 bytes)
- "campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m12/rtl-verilator-results.hjson" (file; 352 bytes)
- "campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m12/dv-verible-results.hjson" (file; 107 bytes)
- "campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m12/xsim-tb-log.txt" (file; 1819 bytes)
- "campaigns/dma-memory-protection-closure-f96de0c2d41b/verifier/m11/result.md" (file; 2239 bytes)

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
