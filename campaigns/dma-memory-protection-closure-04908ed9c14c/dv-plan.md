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
| T0 | Setup and source hygiene | Any long-running work | Clean-base identity, SWB doctor, source-derived footprint table, tool availability | main_agent | complete | no design behavior claim |
| T1 | Static candidate checks | Implementation checkpoint | DMA RTL Verilator lint, DV Verible lint, diff inspection | main_agent | complete | static evidence does not prove runtime behavior |
| T2 | Focused directed behavior | Bounded behavioral claim | `dma_mem_boundary` on an available UVM simulator; focused XSim helper where full UVM is unavailable | verification_agent | focused_helper_complete_full_uvm_pending | helper-only XSim does not prove clocked DMA/scoreboard behavior |
| T3 | Promotion behavioral evidence | Promotion claim | Independently reviewed directed test plus broader DMA regression and coverage review | verification_agent | blocked_pending_signoff | no untested surface implied |
| T4 | Backend/system evidence | Physical or integration claim | Synthesis/QoR and top-level integration evidence if separately authorized | controller | out_of_scope | no physical or silicon claim |

## Promotion Matrix / Coverage Surface

Name each promotion-relevant configuration, mode, parameter, interface,
traffic pattern, reset/clock/CDC condition, error/security condition, and
seed/repetition policy needed for the accepted objective. Mark rows as
`hard_gate`, `diagnostic`, or `out_of_scope`
using the same terminology as the objective ledger.

| Surface ID | Classification | Requirement / Risk | Test or Evidence Method | Pass Criteria | Status | Non-Claims |
| --- | --- | --- | --- | --- | --- | --- |
| BND-DIR | hard_gate | Restricted source export and restricted destination import through CTN and System peers | Directed cases select OT source/destination and CTN/System opposite endpoint | Correct source/destination error and completion status | implemented_pending_run | no OT-to-OT restriction claim |
| BND-WIDTH | hard_gate | One-, two-, and four-byte widths including partial finals | Cross every addressing class and restricted direction; explicit partial final cases | Model and DUT classification agree | implemented_pending_run | no exhaustive size sweep |
| BND-MODE | hard_gate | Incrementing non-wrap, incrementing chunk-wrap, fixed wrapped, fixed-within-chunk non-wrap | 44 directed cases and source-derived helper checks | Exact physical footprint accepted/rejected | implemented_pending_run | variable-divider QoR pending |
| BND-EDGE | hard_gate | Exact base/limit, one-byte under/over, 32-bit carry | Directed positive and negative cases | Inclusive limit accepted; escapes rejected | implemented_pending_run | no formal exhaustive arithmetic proof |
| BND-READ-PHYS | hard_gate | Narrow OT source reads fetch aligned full TL word | Cases with base/limit cutting aligned word | Physical read footprint enforced | implemented_pending_run | no claim for unrelated bus fabric |
| BND-NO-REQ | hard_gate | Invalid config produces no transfer data request | Scoreboard fatal on any source/destination data transaction after invalid classification | Zero such transactions | implemented_pending_run | interrupt-clear writes provisionally excluded |
| BND-CHUNK-ALIGN | hard_gate | Non-final chunk is width-aligned | Directed 2B/4B invalid chunk cases | Size error before transfer request | implemented_pending_run | final partial chunk remains allowed |
| BND-XILINX-UVM | diagnostic | Full directed sequence on XSim | Build/run attempt with OpenTitan UVM | Pass or exact tool incompatibility recorded | blocked_by_uvm_hdl_release_signature | unavailable run is not passing |

## Acceptance Evidence

| Evidence ID | Requirement / Metric | Method | Tool / Flow | Owner | Status | Non-Claims |
| --- | --- | --- | --- | --- | --- | --- |
| EV-RTL-LINT | MP-LINT and structural consistency | DMA-selected Verilator lint plus direct generated lint target if wrapper warning masks result | DVSim/Verilator | main_agent | complete | no functional proof |
| EV-DV-LINT | Directed sequence/model/scoreboard syntax and style | DMA DV Verible lint | DVSim/Verible | main_agent | complete | no runtime proof |
| EV-XSIM-FOCUSED | Footprint helper composition and source structure | Campaign-local XSim testbench | Vivado Simulator | main_agent | complete | no full UVM or bus-monitor proof |
| EV-UVM-DIRECTED | Full boundary behavior and no-data-request check | `dma_mem_boundary` | available supported simulator | verification_agent | pending | no full regression |

## Known Gaps / Deferred Decisions

- Whether interrupt-clear writes must also be suppressed for an invalid
  handshake configuration remains a controller clarification. Until resolved,
  the no-request hard gate covers source-read and destination-write data
  transactions.
- Xcelium availability is unknown; XSim is required to be attempted.
- The sparse fixed/non-wrapped envelope uses variable division; synthesis QoR
  is out of scope and remains a review item.
- Full regression, coverage, formal, and top-level integration are deferred.

## Re-Review Triggers

- objective, hard-gate, baseline, comparison flow, or promotion matrix changes;
- implementation strategy changes that introduce new state, buffering,
  parallelism, interfaces, clocks, resets, CDC/RDC, security, or error surfaces;
- evidence tier changes or verifier downgrades;
- discovered mismatch between measured rows and accepted requirement rows.

## Review Notes

- Initial plan is draft until the verification owner signs it off in
  `initial-packet.md` or a controller records a narrowed-scope exception.
