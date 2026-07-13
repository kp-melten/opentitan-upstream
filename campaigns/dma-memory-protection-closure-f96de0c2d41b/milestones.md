# Campaign Milestones

Current next milestone: M4

| ID | Status | Title | Exit Criteria | Owner | Review |
| --- | --- | --- | --- | --- | --- |
| M0 | complete | Campaign subtree initialized | Campaign scaffold exists on a campaign branch | main_agent | none |
| M1 | pending | Objective, working capability target, and acceptance boundary recorded | For promotion, objective, working capability target, executable design deliverable, readiness ladder, requirements, baselines, hard gates, preferences, diagnostics, non-claims, and authority are recorded with human silicon architect sign-off. A controller-recorded narrowed-scope exception may record the construction boundary only for non-promotion discovery or implementation | human_silicon_architect_plus_controller | required |
| M2 | pending | DV/evidence plan supports the capability target and design deliverable | Full initial DV/evidence plan is reviewable at campaign resolution, covers the working capability target, executable deliverable/readiness ladder, identifies unblocked construction work, and is approved by the DV engineer / verification owner before promotion claims | dv_engineer_plus_verification_agent | required |
| M3 | pending | Initial campaign packet resolved | For promotion, `initial-packet.md` records human silicon architect and DV engineer / verification-owner sign-offs. An explicit controller-recorded narrowed-scope exception may resolve the packet only for non-promotion discovery or implementation with explicit non-claims | human_silicon_architect_plus_dv_engineer_or_controller_exception | required |
| M4 | pending | First meaningful executable design increment | A meaningful RTL, model, BFM, generated-collateral, interface, or integration increment exists, can be locally exercised, and materially reduces distance to the working capability target. This advances construction only; promotion claims still require the M1-M3 gates and verifier-owned evidence | main_agent | implementation_checkpoint |
| M5 | pending | DMA boundary RTL and DV collateral aligned | Overflow-safe exact footprint validation, directed boundary sequence, inclusive scoreboard/model semantics, no-request assertion/equivalent, testplan, and simulation config are reviewable together | main_agent | implementation_checkpoint |
| M6 | pending | Focused checks recorded | DMA Verilator lint and the narrowest available directed simulation are recorded; unavailable simulator work is explicitly pending | main_agent | implementation_checkpoint |
| M7 | pending | Independent review and broader verification | Required sign-offs, verifier review, and any accepted broader regression/coverage work are complete | verification_agent_plus_controller | promotion |

Every closeout should answer the current step delta:

- Which milestone did this advance, block, or leave unchanged?
- What design/work-product became executable, integrated, or explicitly unchanged?
- What is the closeout posture: implementation checkpoint, claim-bearing, or promotion?
- For claim-bearing or promotion closeouts, what evidence and claim-boundary state changed?
- Did accepted objective, DV plan, milestone, requirement, or claim-boundary state change or need review?
- What is the next milestone-directed action?
