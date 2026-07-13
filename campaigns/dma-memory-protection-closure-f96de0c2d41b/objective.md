# Campaign Objective

## Objective

Make the DMA-enabled memory boundary exact, overflow-safe, and consistent across RTL and DV for every transfer addressing mode.

## Working Silicon Capability Target

Name the user-visible or integration-visible capability this campaign is
trying to make real. Prefer a concrete end-to-end behavior over a paperwork
state. Record known gaps as non-claims rather than shrinking the target until
it becomes documentation-only.

- A DMA configuration that crosses between OT internal memory and the CTN or
  system address spaces is validated before any data-bus request. Validation
  covers the exact bytes reachable under fixed, incrementing, chunk-wrapped,
  and non-wrapped multi-chunk addressing, for one-, two-, and four-byte
  transfer widths. The inclusive OT memory limit is honored and 32-bit
  address arithmetic cannot wrap into an apparently valid range.

## Executable Design Deliverable

Describe the concrete design/work-product that should exist when this campaign
succeeds: RTL modules, public interfaces, models, BFMs, generated collateral,
constraints, integration paths, regressions, or lab-independent checks.

- Centralized, overflow-safe footprint validation in `hw/ip/dma/rtl/dma.sv`.
- A directed `dma_mem_boundary_vseq` covering exact fits, one-byte boundary
  failures, arithmetic wraparound, addressing modes, restricted directions,
  and all supported widths.
- An inclusive-range UVM model and scoreboard, plus an assertion or equivalent
  monitor check that a rejected configuration emits no DMA data-bus request.
- DMA testplan and simulation configuration entries, with lint and any
  available directed-simulation evidence recorded in this campaign subtree.

## Readiness Ladder

Name the meaningful readiness levels for this campaign. Prefer levels that say
what becomes elaboratable, simulated, integrated, source-backed, or otherwise
executable before naming the evidence that supports the claim.

| Level | Design / Work-Product State | Required Evidence | Status | Non-Claims |
| --- | --- | --- | --- | --- |
| R0 Source-aligned | RTL, model, scoreboard, testplan, and directed sequence agree on inclusive memory-footprint semantics | Source inspection and reviewable diff | in_progress | No behavioral pass claim |
| R1 Static checked | Candidate passes the DMA Verilator lint target | Recorded command and log | pending | No simulation or regression claim |
| R2 Directed checked | The boundary sequence passes on an available supported simulator | Recorded DVSim result and log | pending | No full regression or coverage closure |
| R3 Promotion reviewed | Independent verifier and required human/DV owners accept the bounded claim | Signed packet, verifier result, and accepted evidence | pending | No top-level, formal, backend, timing, or silicon claim |

## Requirement Ledger

Classify every requirement or metric before using it for acceptance:

| ID | Classification | Target / Threshold | Unit | Baseline | Measurement Method | Evidence Source | Owner / Change Authority | Status | Non-Claims |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| DMA-MP-01 | hard_gate | A transfer whose final accessed byte equals the inclusive limit is accepted | Boolean | Current RTL appears off by one | Directed boundary case and model comparison | Directed simulation or pending simulator record | human_controller; change by human_controller | active | No broader range proof |
| DMA-MP-02 | hard_gate | Access below base or beyond limit raises the direction-appropriate address error | Boolean | Source-inspection risk only | Directed source/destination cases | Directed simulation or pending simulator record | human_controller; change by human_controller | active | No exhaustive fault-injection claim |
| DMA-MP-03 | hard_gate | Any 32-bit effective-footprint arithmetic overflow is rejected | Boolean | Current RTL addition may overflow | Directed wrap cases plus widened RTL arithmetic review | Lint and directed simulation | human_controller; change by human_controller | active | No formal arithmetic proof |
| DMA-MP-04 | hard_gate | Non-wrapped transfers validate the complete reachable footprint | Boolean | Current RTL checks one chunk | Multi-chunk directed cases | Directed simulation | human_controller; change by human_controller | active | No full DMA regression |
| DMA-MP-05 | hard_gate | Fixed and wrapped modes are not rejected for bytes they cannot access | Boolean | Current RTL uses chunk size uniformly | Address-mode footprint table and exact-fit cases | Source review and directed simulation | human_controller; change by human_controller | active | Only supported RTL addressing behavior is covered |
| DMA-MP-06 | hard_gate | Invalid restricted configurations issue no source or destination data-bus transaction | Boolean | FSM intends fail-before-request | Bound assertion/monitor and directed invalid cases | Assertion result in directed simulation | human_controller; change by human_controller | active | Interrupt-clear traffic is outside the data-transfer check |
| DMA-MP-07 | hard_gate | Modified RTL passes the DMA Verilator lint target | Exit code 0 | Not yet run | Repository lint command | Recorded lint output | human_controller; change by human_controller | active | Lint is not behavioral proof |
| DMA-MP-08 | diagnostic | Narrowest available directed simulation passes; commercial-only runs are recorded pending | Result classification | Tool availability unknown | Probe and run DMA DVSim target | Recorded command/log or pending reason | main_agent | active | Unavailable simulation is not implicitly passing |

## Claim Scope

- At the implementation checkpoint, the maximum claim is: the candidate
  implements an overflow-safe DMA memory-footprint check and passes the
  recorded static or directed checks.

## Non-Claims

- No full DMA regression or coverage closure.
- No formal security proof.
- No top-level integration, synthesis, timing, or silicon claim.
- No promotion claim until independently reviewed and the initial packet is signed.
- Simulator-unavailable tests remain pending, not implicitly passing.
