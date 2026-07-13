# DV / Evidence Plan

## Ownership

The verification agent owns DV/evidence-plan adequacy for promotion-relevant
claims. The main agent may draft or propose updates, continue
controller-authorized non-promoted implementation with explicit non-claims, and
delegate verification implementation. The verification agent must independently
approve material changes to claim scope, evidence scope, hard gates, or success
criteria before they are used for promotion; controller or human authority is
also required when those changes alter the accepted objective.

## Initial Plan Boundary

This is the full initial DV/evidence plan at campaign-resolution, not a final
closure report. It should be broad enough for the DV engineer or verification
owner to approve promotion-surface adequacy before stronger RTL claims are
accepted. Keep it live as strategy changes; material changes require verifier
review and, when they alter mission scope or hard gates, controller or human
authority.

For production design, the plan supports construction of the executable
deliverable named in `objective.md`. It should enable substantial,
reviewable implementation increments rather than forcing tiny evidence-only
slices unless a real risk or blocker justifies that shape.
When a claim is blocked or narrowed, the plan should help the main agent keep
moving by separating the missing proof from implementation work that does not
depend on that proof.
The plan should also optimize iteration cost: identify the fastest checks that
catch likely design bugs, the deeper checks needed before promotion, and which
larger design increments are efficient enough to review as one unit.

## Evidence Tiers

| Tier | Purpose | Required Before | Evidence / Method | Owner | Status | Non-Claims |
| --- | --- | --- | --- | --- | --- | --- |
| T0 | Setup and source hygiene | Any long-running work | Branch/base identity, dirty-state check, tool availability, reproducible command shape | main_agent | draft | no design behavior claim |
| T1 | Fast behavioral scout | Architecture exploration | Focused tests, fixtures, assertions, or model comparisons that expose the intended behavior/risk | main_agent / optional_worker | draft | not promotion closure unless verifier accepts scope |
| T2 | Promotion behavioral evidence | Promotion-relevant RTL claim | Accepted matrix of modes/configs/seeds/traffic/reset/error/security surfaces with pass/fail criteria | verification_agent | draft | no untested surface implied |
| T3 | Implementation/QoR evidence | QoR or physical claim | Same-flow synthesis/timing/area/power/backend reports named by the objective | main_agent | draft | no signoff beyond named flow |
| T4 | Final campaign evidence | Deliverable candidate | DV engineer accepted regression/coverage/formal/backend/lab evidence named by the campaign objective | verification_agent + controller | draft | no broader product signoff |

## Promotion Matrix / Coverage Surface

Name each promotion-relevant configuration, mode, parameter, interface,
traffic pattern, reset/clock/CDC condition, error/security condition, and
seed/repetition policy needed for the accepted objective. Mark rows as
`hard_gate`, `diagnostic`, or `out_of_scope`
using the same terminology as the objective ledger.

| Surface ID | Classification | Requirement / Risk | Test or Evidence Method | Pass Criteria | Status | Non-Claims |
| --- | --- | --- | --- | --- | --- | --- |
| MP-BASE-LIMIT | hard_gate | Inclusive base/limit semantics, exact fit, one-byte underflow and overflow | `dma_mem_boundary_vseq` directed cases | Correct error result; exact-limit fit accepted | planned | No exhaustive address proof |
| MP-WRAP | hard_gate | 32-bit OT and CTN source/destination end-address arithmetic wraparound | Near-`32'hffff_ffff` directed cases on both 32-bit interfaces | Direction-appropriate address error before any DMA data request | planned | No formal proof |
| MP-MODES | hard_gate | Fixed, incrementing, chunk-wrap, and non-wrapped multi-chunk logical footprints plus aligned full-word source-read footprints | Mode/width/direction matrix in directed sequence | RTL and model agree with expected physical bus footprint and result | planned | Only configured cases imply coverage |
| MP-WIDTHS | hard_gate | One-, two-, and four-byte transfer widths, aligned full-word narrow reads, and final partial accesses | Cross each supported width with boundary cases | Correct inclusive physical final-byte decision | planned | No unsupported width claim |
| MP-DIRECTIONS | hard_gate | OT-to-CTN/system and CTN/system-to-OT restricted directions | Source- and destination-restricted directed cases | Direction-appropriate address error | planned | OT-to-OT range behavior is out of restriction scope |
| MP-NO-REQUEST | hard_gate | Invalid configuration produces no source or destination DMA data request | SVA or equivalent monitor bound to internal request/state signals | No assertion failure for rejected cases | planned | Interrupt-clear transactions are excluded |
| MP-LINT | hard_gate | RTL remains lint-clean on DMA Verilator target | Repository lint command | Exit status zero | planned | Static only |
| MP-REGRESSION | out_of_scope | Full DMA regression and coverage closure | Deferred to independent verification | Not required for implementation checkpoint | deferred | Explicit non-claim |

## Acceptance Evidence

| Evidence ID | Requirement / Metric | Method | Tool / Flow | Owner | Status | Non-Claims |
| --- | --- | --- | --- | --- | --- | --- |
| E-MP-SOURCE | DMA-MP-01 through DMA-MP-06 | Review footprint table, RTL/DV diff, and fail-before-request structure | Source inspection | verification_agent | pending | Guidance until independently reviewed |
| E-MP-LINT | DMA-MP-07 | DMA Verilator lint target | Verilator/DVSim | main_agent | pending | No behavioral claim |
| E-MP-DIRECTED | DMA-MP-01 through DMA-MP-06 and DMA-MP-08 | Directed boundary sequence | Available supported simulator | verification_agent | pending | No full regression or coverage closure |

## Known Gaps / Deferred Decisions

- Commercial simulator availability is unknown and will be probed; unavailable
  runs remain pending.
- Independent DV-plan review and promotion review are deferred under the
  controller-recorded implementation exception.
- Full DMA regression, coverage closure, and formal security proof are out of
  scope for this checkpoint.

## Re-Review Triggers

- objective, hard-gate, baseline, comparison flow, or promotion matrix changes;
- implementation strategy changes that introduce new state, buffering,
  parallelism, interfaces, clocks, resets, CDC/RDC, security, or error surfaces;
- evidence tier changes or verifier downgrades;
- discovered mismatch between measured rows and accepted requirement rows.

## Review Notes

- Initial plan is draft until the verification owner signs it off in
  `initial-packet.md` or a controller records a narrowed-scope exception.
