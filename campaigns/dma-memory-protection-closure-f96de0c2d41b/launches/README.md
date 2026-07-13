# Campaign Launches

Claim-bearing agent launches should have a controller-authored launch authority
record under:

```text
campaigns/dma-memory-protection-closure-f96de0c2d41b/launches/<launch-id>/launch-authority.json
```

Generate the record from a tracked clean campaign-owned runtime lock and MCP
bundle:

```bash
swb campaign launch-authority --workspace <design-worktree> --support-profile-id opentitan-dma --campaign-id dma-memory-protection-closure-f96de0c2d41b --launch-id <launch-id> --lock campaigns/dma-memory-protection-closure-f96de0c2d41b/runtime-lock.json --bundle campaigns/dma-memory-protection-closure-f96de0c2d41b/mcp-bundle.json --recorded-by <controller-id> --authority-boundary "<accepted runtime/bundle boundary>"
```

The record names the accepted runtime-lock identity, expected SWB runtime
digest, required runtime capabilities, MCP bundle identity, campaign id, support
profile id, and launch id. It is a git-owned campaign selector record. It is not
design evidence and does not by itself prove an enforceable controller or
remote-worker boundary. Commit and push it before claim-bearing launch.

Validate a claim-bearing launch record with:

```bash
swb campaign check --workspace <design-worktree> --support-profile-id opentitan-dma --campaign-id dma-memory-protection-closure-f96de0c2d41b --launch-id <launch-id> --fetch
```

When readiness also receives `--lock`, `--launch-id` lets SWB derive the
accepted runtime-lock hash from the launch-authority record. Passing both
`--launch-id` and `--accepted-runtime-lock-hash` is allowed only when they
match exactly.
