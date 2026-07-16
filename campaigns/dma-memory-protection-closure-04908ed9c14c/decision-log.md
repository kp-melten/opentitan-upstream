# Decision Log

## D1 — use canonical OpenTitan repo and local campaign branch

- Date: 2026-07-16
- Decision: run directly in `opentitan-upstream` on
  `campaign/dma-memory-protection-closure-04908ed9c14c`.
- Rationale: the worktree was clean at `origin/master`; no private mirror is
  needed for this local implementation checkpoint.
- Authority: user request plus SWB repo guidance.
- Non-claim: branch is not pushed or promotion-authorized.

## D2 — reuse prior source delta as neutral collateral

- Date: 2026-07-16
- Decision: import only the DMA RTL/DV/docs delta from the prior campaign
  based on the same master commit; exclude its campaign ledger, evidence,
  launch records, and unrelated `prim_diff_decode` change.
- Rationale: production design permits source history, but prior logs do not
  prove the current worktree.
- Next check: independently inspect the diff and rerun all cited checks into
  this campaign.

## D3 — provisional no-request boundary

- Date: 2026-07-16
- Decision: MP-NO-DATA-REQ currently forbids source-read and
  destination-write data requests after invalid configuration classification.
  Configured interrupt-clear writes are excluded pending user clarification.
- Rationale: the hard gate explicitly names source/destination transactions,
  while the working target also uses the broader phrase “any bus request.”
- Status: open controller question; no promotion claim.

## D4 — repair selected-target dependency width warning

- Date: 2026-07-16
- Decision: apply the prior campaign's typed-width cleanup to
  `hw/ip/prim/rtl/prim_diff_decode.sv`.
- Evidence: the fresh DMA Verilator target failed solely on
  `skew_cnt_q < SkewCycles` width expansion in that dependency. The change
  sizes the counter and compare operand consistently and preserves the
  inclusive `0..SkewCycles` behavior.
- Claim impact: enables the required DMA lint target; does not establish a
  broader prim functional or regression claim.

| Date | Decision ID | Owner | Decision | Evidence / Reference | Claim Impact |
| --- | --- | --- | --- | --- | --- |
| 2026-07-16 | campaign-init | main_agent | Initialized campaign scaffold | campaigns/dma-memory-protection-closure-04908ed9c14c/ | no design claim |
