# M8 Lint-Resolution Check Summary

Date: 2026-07-14
Base campaign commit: `591bcfb34f2a48025c517bd1e0cb1a1eddfb99d2`

## Source delta

This checkpoint keeps the existing DMA memory-footprint implementation and adds
explicit-width lint cleanup needed to satisfy the DMA Verilator lint surface:

- `hw/ip/prim/rtl/prim_diff_decode.sv`: made the skew counter width and
  comparison explicit so the DMA lint dependency no longer emits the prior
  `prim_diff_decode.sv:162` width diagnostic.
- `hw/ip/dma/rtl/dma.sv`: explicitly extended `total_data_size` before the
  SHA message-length shift and explicitly cast DMA error enum indices when
  indexing the packed `next_error` vector.

These edits are intended as width-contract cleanup only; they do not change the
DMA footprint policy established by candidate C1.

## DMA Verilator lint

Command:

```text
dvsim hw/top_darjeeling/lint/top_darjeeling_lint_cfgs.hjson --tool verilator --local --purge --select-cfgs dma --scratch-root campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m8/dma-verilator
```

Observed DVSim result: nonzero wrapper exit because the flow records the Edalize
backend deprecation as a flow warning. The generated `results.hjson` reports:

- flow errors: 0
- lint warnings: 0
- lint errors: 0

Generated result path:
`checks/m8/dma-verilator-summary/results.hjson`.

The generated DMA `make lint-only` target was then run directly from the DVSim
scratch tree:

```text
make -C <generated dma-verilator fusesoc-work> lint-only
```

Result: exit code 0. Log:
`checks/m8/direct-make-lint/make-lint-only.log`.

## Directed boundary simulation

Command:

```text
dvsim hw/ip/dma/dv/dma_sim_cfg.hjson --items dma_mem_boundary --reseed 1 --local --purge --scratch-root campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m8/directed-xcelium
```

Result: unavailable/pending. DVSim recognized `dma_mem_boundary`, generated the
Xcelium build, and then failed at build time because `xrun` is not installed on
PATH:

```text
bash: line 1: xrun: command not found
```

No simulation behavior, no-request dynamic proof, regression pass, or coverage
claim is made.

## Claim boundary

Supported implementation-checkpoint claim:

- The source candidate contains the centralized overflow-safe DMA memory
  footprint implementation from C1 plus explicit-width cleanup.
- The generated DMA Verilator lint invocation reports zero flow errors, lint
  warnings, and lint errors; the generated `make lint-only` target exits 0 in
  this environment.

Non-claims:

- The DVSim wrapper command itself still exits nonzero due to a flow warning,
  so this is not recorded as a clean end-to-end DVSim-wrapper pass.
- Directed Xcelium simulation remains pending because `xrun` is unavailable.
- No behavioral pass, no-request dynamic proof, full regression, coverage
  closure, formal security proof, integration, synthesis, timing, silicon, or
  promotion claim.
