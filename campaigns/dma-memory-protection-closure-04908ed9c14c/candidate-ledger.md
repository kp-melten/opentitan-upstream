# Candidate Ledger

## C1 — exact physical DMA footprint candidate

- Base: `58f8fdd5396817b775d2c69af9a6322ac7a84e5a`
- Provenance: reviewed source delta from prior campaign branch
  `origin/campaign/dma-memory-protection-closure-f96de0c2d41b`, which is based
  on the same master commit. Prior evidence is guidance only; this campaign
  requires fresh checks.
- Design delta: centralized overflow-safe RTL footprint validation, physical
  OT source-read modeling, exact inclusive scoreboard checking, 44-case
  directed sequence, testplan/config entries, documentation, and a
  behavior-preserving `prim_diff_decode` counter-width cleanup required for the
  selected DMA Verilator target to complete.
- Implementation commit: `d1038f6154ed90667756fba454fe023bc04bf8be`.
- Status: implementation checkpoint with fresh static and focused XSim evidence;
  full UVM evidence pending.
- Risks: variable-divider synthesis/QoR; full UVM simulator availability;
  interrupt-clear behavior for invalid handshake configurations awaits
  controller clarification.
- Non-claims: no promotion, full regression, coverage, formal, integration,
  synthesis, timing, or silicon claim.

Record every candidate base and promotion-relevant source identity here.

| Candidate ID | Base Ref / Commit | Implementation Commit | Measurement Anchors | Status | Claims | Non-Claims |
| --- | --- | --- | --- | --- | --- | --- |
| C1 | `58f8fdd5396817b775d2c69af9a6322ac7a84e5a` | `d1038f6154ed90667756fba454fe023bc04bf8be` | EV-RTL-LINT, EV-DV-LINT, EV-XSIM-FOCUSED; EV-UVM-DIRECTED pending | implementation_checkpoint | recorded static and focused-check claim only | no promotion or full closure |
| C2 | `d1038f6154ed90667756fba454fe023bc04bf8be` | `c9619cb7610e9554eae1b812a5fadd7fd9fa32ac` | M8 EV-RTL-LINT, EV-DV-LINT, EV-XSIM-FOCUSED; EV-UVM-DIRECTED pending | implementation_checkpoint_pending_verifier | strict all-request source boundary plus exact-revision static/focused checks | no full UVM, regression, or promotion claim |

## C2 — strict pre-request validation candidate

- Design delta: handshake triggers enter `DmaAddrSetup` before interrupt
  clearing; valid configurations clear and then revalidate before data motion.
  The scoreboard rejects interrupt-clear traffic for invalid configurations,
  the directed sequence contains 45 cases including a handshake-clear invalid
  case, and the focused XSim helper checks both invalid and valid sequencing.
- Implementation commit: `c9619cb7610e9554eae1b812a5fadd7fd9fa32ac`.
- Status: exact-revision lint and focused XSim evidence complete; independent
  re-review and full UVM execution pending.
- Non-claims: no promotion, full regression, coverage, formal, integration,
  synthesis/QoR, timing, or silicon claim.
