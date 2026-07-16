# M11 DMA Memory-Protection Closure Check Summary

Date: 2026-07-15 America/Chicago
Base campaign commit: `62c937ed15`

## Candidate delta

- Corrected the fixed-within-chunk, non-wrapped (`increment=0`, `wrap=0`)
  footprint to the exact sparse address envelope used by RTL across chunk starts.
- Rejects non-final chunks that are not integral multiples of the transfer width
  before any data-bus request, matching the transfer/chunk counter behavior.
- Mirrors the footprint and configuration classification in the UVM item and
  expands `dma_mem_boundary_vseq` to 44 directed cases.
- Adds a reproducible campaign-local XSim check and runner.

## Static checks

DMA DV Verible lint completed with zero flow warnings/errors and zero lint
warnings/errors. DMA RTL Verilator generated results contain zero flow errors and zero
lint warnings/errors. The DVSim wrapper returns nonzero solely because it promotes the
known Edalize backend deprecation warning; the generated DMA `make lint-only` target
exits 0. Compact and raw results are stored beside this summary.

Commands:

```text
dvsim hw/top_darjeeling/lint/top_darjeeling_lint_cfgs.hjson --tool verilator --local --purge --select-cfgs dma --scratch-root campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m11/final-rtl-verilator
dvsim hw/top_darjeeling/lint/top_darjeeling_lint_cfgs.hjson --tool veriblelint --local --purge --select-cfgs dma --scratch-root campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m11/final-dv-verible
make -C campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m11/final-rtl-verilator/campaign-dma-memory-protection-closure-f96de0c2d41b/dma-lint-verilator/default/fusesoc-work lint-only
```

Raw evidence digests:

- `raw-rtl-verilator-results.hjson`: `f28be58438cbe300dbf973d8fd62dee77c1c56ddd2f0d778037c92ecb2a6d50e`
- `raw-rtl-verilator-log.txt`: `0d57479eaadffc8b067534f9382cf5b2d1f1baad378c46c7082ec24404b0e4ba`
- `raw-dv-verible-results.hjson`: `d190f411eea5b783a51d963ff83a9aa99313cec71546dc714b0357ac260e4926`
- `raw-dv-verible-log.txt`: `ceda0a7b09d76fa4ea9a1980744858ffe1598eac0c0fd67328403735efc9ca68`

Tool identities:

- Verilator 5.020 (Debian 5.020-1)
- Verible v0.0-4051-g9fdb4057

## Focused simulation

The campaign-local XSim runner passed with
`DMA_FOOTPRINT_XSIM_PASS checks=44` on Vivado Simulator 2025.2.1. See
`xsim-footprint-result.md` for scope and limitations.

## Pending verification and non-claims

The full UVM `dma_mem_boundary` test was not run: Xcelium is unavailable (`xrun` is
absent), and the focused XSim harness is intentionally not a UVM substitute. Full DMA
regression, coverage closure, formal security proof, top-level integration, synthesis,
timing, silicon, and promotion remain non-claims. The variable division used to derive
the sparse final chunk envelope has not been evaluated for synthesis QoR.
