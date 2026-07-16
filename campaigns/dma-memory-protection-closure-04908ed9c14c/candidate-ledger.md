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
- Status: implementation candidate; fresh evidence pending.
- Risks: variable-divider synthesis/QoR; full UVM simulator availability;
  interrupt-clear behavior for invalid handshake configurations awaits
  controller clarification.
- Non-claims: no promotion, full regression, coverage, formal, integration,
  synthesis, timing, or silicon claim.

Record every candidate base and promotion-relevant source identity here.

| Candidate ID | Base Ref / Commit | Implementation Commit | Measurement Anchors | Status | Claims | Non-Claims |
| --- | --- | --- | --- | --- | --- | --- |
| C1 | `58f8fdd5396817b775d2c69af9a6322ac7a84e5a` | uncommitted candidate | EV-RTL-LINT, EV-DV-LINT, EV-XSIM-FOCUSED, EV-UVM-DIRECTED | implementation | bounded checkpoint pending fresh checks | no promotion or full closure |
