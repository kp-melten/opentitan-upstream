# Campaign SWB Support

This directory records campaign-local support metadata for Silicon Workbench.
It is reviewable campaign content, not SWB-owned executable policy and not
evidence by itself.

Start with `support.yaml`. Use it to point agents and verifiers at
campaign-local configs, checks, fixtures, parser schemas, repo tools, and
SWB-owned common tools used by this campaign. Entries may include
`prerequisites` metadata such as environment variables, PATH prefixes,
packages, and setup notes needed to reproduce a route. That metadata is not
evidence that the route was executed.

Inspect the support boundary with:

```bash
swb campaign tools --workspace <design-worktree> --support-profile-id opentitan-dma --campaign-id dma-memory-protection-closure-04908ed9c14c
```

Keep project-specific claim meaning, accepted warning allowlists, matrix
configs, expected totals, evidence tiers, supported claims, non-claims, and
test vectors here or in canonical repo paths referenced from `support.yaml`.
Move helpers that are useful beyond SWB into ordinary repo `tools/`
after they are accepted upstream.
