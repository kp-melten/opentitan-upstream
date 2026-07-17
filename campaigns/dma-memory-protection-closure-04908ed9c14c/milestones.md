# Campaign Milestones

Current next milestone: M8

| ID | Status | Title | Exit Criteria | Owner | Review |
| --- | --- | --- | --- | --- | --- |
| M0 | complete | Campaign subtree initialized | Campaign scaffold exists on a campaign branch | main_agent | none |
| M1 | pending | Objective, working capability target, and acceptance boundary recorded | For promotion, objective, working capability target, executable design deliverable, readiness ladder, requirements, baselines, hard gates, preferences, diagnostics, non-claims, and authority are recorded with human silicon architect sign-off. A controller-recorded narrowed-scope exception may record the construction boundary only for non-promotion discovery or implementation | human_silicon_architect_plus_controller | required |
| M2 | pending | DV/evidence plan supports the capability target and design deliverable | Full initial DV/evidence plan is reviewable at campaign resolution, covers the working capability target, executable deliverable/readiness ladder, identifies unblocked construction work, and is approved by the DV engineer / verification owner before promotion claims | dv_engineer_plus_verification_agent | required |
| M3 | pending | Initial campaign packet resolved | For promotion, `initial-packet.md` records human silicon architect and DV engineer / verification-owner sign-offs. An explicit controller-recorded narrowed-scope exception may resolve the packet only for non-promotion discovery or implementation with explicit non-claims | human_silicon_architect_plus_dv_engineer_or_controller_exception | required |
| M4 | complete | First meaningful executable design increment | A meaningful RTL, model, BFM, generated-collateral, interface, or integration increment exists, can be locally exercised, and materially reduces distance to the working capability target. This advances construction only; promotion claims still require the M1-M3 gates and verifier-owned evidence | main_agent | implementation_checkpoint |
| M5 | complete | Exact RTL and DV boundary candidate | Centralized physical-footprint validation, directed boundary sequence, model/scoreboard agreement, no-data-request checking, testplan/config entries, and documentation form one reviewable candidate | main_agent | implementation_checkpoint |
| M6 | complete | Static and focused directed checks recorded | DMA Verilator lint, DV lint, and the narrowest available Xilinx simulation are recorded with exact pending gaps | main_agent_plus_verification_agent | implementation_checkpoint |
| M7 | complete | Campaign checkpoint closeout | Campaign artifacts record work completed, evidence, branch state, verifier findings, claim boundary, and remaining verification | main_agent | implementation_checkpoint |
| M8 | pending | Complete no-request verification and run full directed UVM | Strict interrupt-clear suppression is implemented and focused-check evidence is recorded; exit still requires the directed sequence on a supported UVM simulator and independent review of the exact candidate | verification_agent | required_for_stronger_claim |

Every closeout should answer the current step delta:

- Which milestone did this advance, block, or leave unchanged?
- What design/work-product became executable, integrated, or explicitly unchanged?
- What is the closeout posture: implementation checkpoint, claim-bearing, or promotion?
- For claim-bearing or promotion closeouts, what evidence and claim-boundary state changed?
- Did accepted objective, DV plan, milestone, requirement, or claim-boundary state change or need review?
- What is the next milestone-directed action?
