# M12 Clean-Candidate Replay Summary

Date: 2026-07-15 America/Chicago
Candidate commit: `85da665f36ba966340fd3888ae15372527ca91b8`
Worktree state at check start: clean

The implementation commit was replayed after commit on the same three focused
surfaces used for M11:

- DMA DV Verible lint: wrapper exit 0; zero flow warnings/errors and zero lint
  warnings/errors.
- DMA RTL Verilator: generated report has zero flow errors and zero lint
  warnings/errors; the DVSim wrapper exits nonzero only for the Edalize backend
  deprecation flow warning; direct generated `make lint-only` exits 0.
- Campaign-local XSim: `DMA_FOOTPRINT_XSIM_PASS checks=44` on Vivado Simulator
  2025.2.1.

Commands:

```text
dvsim hw/top_darjeeling/lint/top_darjeeling_lint_cfgs.hjson --tool verilator --local --purge --select-cfgs dma --scratch-root campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m12/rtl-verilator
dvsim hw/top_darjeeling/lint/top_darjeeling_lint_cfgs.hjson --tool veriblelint --local --purge --select-cfgs dma --scratch-root campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m12/dv-verible
make -C campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m12/rtl-verilator/campaign-dma-memory-protection-closure-f96de0c2d41b/dma-lint-verilator/default/fusesoc-work lint-only
campaigns/dma-memory-protection-closure-f96de0c2d41b/swb-support/checks/run_dma_footprint_xsim.sh campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m12/xsim
```

Raw evidence SHA-256 digests:

- `dv-verible-log.txt`: `ceda0a7b09d76fa4ea9a1980744858ffe1598eac0c0fd67328403735efc9ca68`
- `dv-verible-results.hjson`: `d190f411eea5b783a51d963ff83a9aa99313cec71546dc714b0357ac260e4926`
- `rtl-verilator-log.txt`: `0d57479eaadffc8b067534f9382cf5b2d1f1baad378c46c7082ec24404b0e4ba`
- `rtl-verilator-results.hjson`: `f28be58438cbe300dbf973d8fd62dee77c1c56ddd2f0d778037c92ecb2a6d50e`
- `xsim-tb-log.txt`: `336f5b79cb99014697cbd73584d6bcba2dfd073ca0fc9776e3db9c839007ada9`

The XSim scope remains a focused helper/composition and forced-setup structural
check. The full UVM test, multi-chunk runtime evolution, scoreboard execution,
and bus-monitor-level no-request evidence remain pending. All broader non-claims
from M11 remain unchanged.
