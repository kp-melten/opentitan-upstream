# DMA Memory-Protection Closure

Campaign ID: `dma-memory-protection-closure-f96de0c2d41b`
Support profile ID: `opentitan-dma`
Campaign artifact root: `campaigns/dma-memory-protection-closure-f96de0c2d41b`

## Start Here

1. Read `initial-packet.md` for the campaign-resolution packet and sign-off ledger.
2. Read `objective.md` and `objective.json` for accepted objectives, requirement classifications, baselines, measurement methods, owners, and non-claims.
3. Read `dv-plan.md` for the verifier-owned DV/evidence plan.
4. Read `milestones.md` and `milestones.json` for current campaign state and next milestone-directed action.
5. Read `candidate-ledger.md` for candidate bases, commits, measurement anchors, and source identity.
6. Read `decision-log.md` for controller, human, verifier, and main-agent decisions.

Build toward the executable design objective first. Do not ask for promotion
claims until `initial-packet.md` records human silicon architect and DV
engineer sign-offs. A controller-recorded narrowed-scope exception authorizes
non-promotion discovery or implementation with explicit non-claims; absence of
promotion sign-off limits what can be claimed, not every useful construction
step.

Run campaign hygiene checks before and after accepted campaign commits:

```bash
swb campaign check --workspace <design-worktree> --support-profile-id opentitan-dma --campaign-id dma-memory-protection-closure-f96de0c2d41b --fetch
```

For promotion-ready checks, add `--require-initial-packet-signed` so
controller-recorded discovery/implementation exceptions block instead of only
warning.

Accepted campaign changes should be committed on the protected campaign branch
and pushed to `origin` before long-running work continues.

Store claim-relevant tool output, handoff packets, evidence, and closeout
records under the git-owned `campaigns/dma-memory-protection-closure-f96de0c2d41b/` subtree. Current SWB agent-runtime helpers accept the
campaign-owned surfaces `artifacts/`, `checks/`, `evidence/`,
`tool-runs/`, and `verifier/` below `campaigns/dma-memory-protection-closure-f96de0c2d41b/`.
