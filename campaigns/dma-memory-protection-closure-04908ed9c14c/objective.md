# Campaign Objective

## Objective

Make the DMA-enabled memory boundary exact, overflow-safe, and consistent across RTL and DV for every transfer addressing mode.

## Working Silicon Capability Target

- The DMA rejects an OT-memory import or export before any source-read,
  destination-write, or configured handshake interrupt-clear request when the
  physical accessed-byte footprint is below the inclusive base, above the
  inclusive limit, or wraps a 32-bit address space.
- Footprints match the RTL bus behavior for fixed-within-chunk, incrementing,
  chunk-wrapped, and non-wrapped multi-chunk transfers at one-, two-, and
  four-byte widths.
- OT source-read footprints include the aligned full-word TL-UL Get issued by
  the host adapter; destination footprints include only enabled write lanes.

## Executable Design Deliverable

- Centralized overflow-safe footprint calculation and validation in
  `hw/ip/dma/rtl/dma.sv`.
- A directed `dma_mem_boundary_vseq`, inclusive-range model and scoreboard
  agreement, invalid-configuration no-request checking, testplan/sim
  registration, and supporting documentation.
- Fresh DMA RTL lint, DV lint, and the narrowest available Xilinx simulation
  evidence recorded under this campaign subtree.

## Readiness Ladder

| Level | Design / Work-Product State | Required Evidence | Status | Non-Claims |
| --- | --- | --- | --- | --- |
| R0 | Source-inspected footprint table and campaign boundary | Source references and campaign artifacts | complete | no behavioral pass claim |
| R1 | RTL/DV candidate implements the complete boundary surface | Reviewable diff plus directed test source | complete | no simulator or regression claim |
| R2 | Candidate passes recorded static and focused directed checks | DMA Verilator lint, DV lint, and available Xilinx check logs | complete | no full UVM regression or promotion claim |
| R3 | Promotion candidate independently reviewed | Signed initial packet and independently accepted behavioral evidence | blocked_pending_signoff | no promotion before human/DV authority |

## Requirement Ledger

| ID | Classification | Target / Threshold | Unit | Baseline | Measurement Method | Evidence Source | Owner / Change Authority | Status | Non-Claims |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| MP-INC-LIMIT | hard_gate | Final physically accessed byte equal to inclusive limit is accepted | behavior | baseline uses inconsistent `+ size` / `+ size - 1` checks | directed boundary cases | UVM/XSim/static evidence | human_controller | active | no full regression |
| MP-RANGE | hard_gate | Any physical byte below base or above limit raises direction-correct address error | behavior | baseline semantics disagree across RTL/model/scoreboard | directed source/destination cases | UVM/XSim/static evidence | human_controller | active | no full-UVM pass claim |
| MP-WRAP | hard_gate | Any applicable 32-bit physical footprint carry is rejected | behavior | baseline arithmetic may wrap | widened arithmetic and directed wrap cases | RTL lint plus directed evidence | human_controller | active | no formal proof |
| MP-NONWRAP | hard_gate | Non-wrapped transfer validates its complete reachable envelope | behavior | baseline checks one chunk | mode/width matrix | directed evidence | human_controller | active | sparse holes need not be inside the logical object, only the enclosing enabled region |
| MP-EXACT-MODES | hard_gate | Fixed and wrapped modes exclude bytes they cannot reach | behavior | baseline over-approximates some modes | source-derived footprint table and directed cases | RTL/DV source plus simulation | human_controller | active | variable-divider QoR not accepted |
| MP-NO-DATA-REQ | hard_gate | Invalid configuration emits no source-read, destination-write, or handshake interrupt-clear request | transaction | baseline handshake path cleared interrupts before `DmaAddrSetup` | scoreboard fatal checks, directed invalid case, and focused XSim sequencing checks | XSim plus UVM evidence when available | verification_owner | active | full-UVM execution pending |
| MP-LINT | hard_gate | DMA Verilator lint target exits successfully | command exit | initial fresh run exposed dependency warning | DMA lint flow and generated target | campaign checks | main_agent | complete | no synthesis/timing claim |
| MP-XILINX | diagnostic | Narrowest credible Xilinx simulation runs | command/result | prior history only | XSim focused helper and full-UVM build attempt | campaign checks | main_agent | complete_with_full_uvm_pending | focused helper is not full DMA behavioral simulation |

## Claim Scope

- At checkpoint, the strongest requested claim is: the candidate implements an
  overflow-safe DMA memory-footprint check and passes the specifically recorded
  static or directed checks.

## Non-Claims

- No full DMA regression or coverage closure.
- No formal security proof.
- No top-level integration, synthesis, timing, area, power, or silicon claim.
- No promotion claim until independently reviewed and the initial packet is
  signed by the required human and DV authorities.
- Unavailable commercial-simulator tests remain pending.
- Variable division used for the sparse fixed/non-wrapped envelope has no QoR
  acceptance in this campaign.
