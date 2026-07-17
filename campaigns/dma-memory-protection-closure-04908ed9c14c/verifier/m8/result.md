# M8 Independent Verification Result

Date: 2026-07-16 America/Chicago
Verifier: separate verification agent
Source candidate: `c9619cb7610e9554eae1b812a5fadd7fd9fa32ac`
Recording revision reviewed: `bb74f9589e337c39ee3ccb0ddf64ccd7912a1ae5`
Disposition: accepted for non-promotion implementation checkpoint

## Findings

- The prior strict-request blocker is closed. A handshake trigger enters
  `DmaAddrSetup` before interrupt clearing; an invalid configuration enters
  `DmaError`; only a valid configuration may enter `DmaClearIntrSrc`.
- After valid interrupt clearing, `intr_clear_done_q` returns the controller
  through validation before `DmaSendRead`, preserving clear-before-data
  behavior without permitting an invalid clear request.
- The scoreboard fatally rejects every external DMA transaction when the DV
  model classifies the configuration invalid, including interrupt-clear
  writes.
- Directed case 45 configures an invalid handshake transfer with an active
  interrupt-clear source.
- Exact-candidate RTL lint and DV lint are clean, direct Verilator lint exits
  0, evidence digests are coherent, and focused XSim reports
  `DMA_FOOTPRINT_XSIM_PASS checks=49`.
- The centralized footprint formulas are unchanged from the previously
  reviewed implementation. The prior bounded enumeration across modes,
  widths, sizes, and aligned offsets remains applicable; no arithmetic,
  inclusive-limit, physical-read, direction, or addressing-mode mismatch was
  found.
- At recording revision `bb74f9589e`, the worktree was clean, M8 evidence and
  ledgers were committed, and `git diff --quiet c9619cb761..bb74f9589e --
  hw/ip/dma hw/ip/prim` returned 0.

No remaining source-level footprint correctness blocker was identified.

## Supported claim

> Candidate `c9619cb7610e9554eae1b812a5fadd7fd9fa32ac`, durably recorded by
> `bb74f9589e337c39ee3ccb0ddf64ccd7912a1ae5`, implements the reviewed
> overflow-safe DMA footprint validation, validates configurations before every
> DMA request class, preserves valid interrupt-clear-before-data sequencing,
> and passes the recorded exact-revision static and focused XSim checks.

## Pending gaps / non-claims

- The complete 45-case UVM sequence has not run.
- No broader regression, coverage, formal, synthesis/QoR, integration, timing,
  silicon, or promotion claim is supported.
- Initial human silicon-architect and DV-owner promotion sign-offs remain
  pending.
