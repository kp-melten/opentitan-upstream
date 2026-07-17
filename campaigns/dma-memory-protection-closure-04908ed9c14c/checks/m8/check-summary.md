# M8 Strict No-Request Checks

Date: 2026-07-16 America/Chicago
Candidate: `c9619cb7610e9554eae1b812a5fadd7fd9fa32ac`
Posture: implementation checkpoint

## Static checks

- DMA DV Verible lint passed with no flow or lint warnings/errors. The exact
  result is `dv-verible-c9619cb761-results.hjson`.
- The DMA DVSim/Verilator result contains no flow errors and no lint
  warnings/errors. DVSim nevertheless returned 1 because it promotes the
  Edalize legacy-backend deprecation warning to run failure.
- The generated candidate-specific `lint-only` target was run directly and
  returned 0. `direct-make-lint-c9619cb761.log` records:

```text
verilator --lint-only -f lowrisc_ip_dma_0.1.vc -DDISABLE_PRIM_CDC_RAND_DELAY -Wall
COMMAND_EXIT_CODE="0"
```

Commands:

```text
dvsim hw/top_darjeeling/lint/top_darjeeling_lint_cfgs.hjson --tool verilator --select-cfgs dma --scratch-root campaigns/dma-memory-protection-closure-04908ed9c14c/checks/m8/rtl-verilator-c9619cb761 --purge
dvsim hw/top_darjeeling/lint/top_darjeeling_dv_lint_cfgs.hjson --tool veriblelint --select-cfgs dma --scratch-root campaigns/dma-memory-protection-closure-04908ed9c14c/checks/m8/dv-verible-c9619cb761 --purge
make -C <candidate-specific-generated-fusesoc-work> lint-only
```

## Xilinx focused simulation

`swb tool run vivado-env` sourced Vivado 2025.2.1, required `xvlog`, `xelab`,
and `xsim`, and ran the campaign helper on the exact candidate. The helper pins
generic primitive and Darjeeling core mappings for reproducible dependency
selection. It passed:

```text
DMA_FOOTPRINT_XSIM_PASS checks=49
```

The 49 checks cover the footprint functions, inclusive ranges, applicable
32-bit carries, all addressing shapes, physical source reads, rejected setup
request suppression, handshake-trigger validation before interrupt clearing,
and the valid clear-then-transfer sequencing path.

The full OpenTitan `dma_mem_boundary` UVM test did not run. The M6 XSim build
attempt remains blocked in common OpenTitan `sec_cm` code because XSim's UVM
library requires a second argument to `uvm_hdl_release`. `xrun`, `vcs`, and
`vsim` are absent on this host. This is pending, not a pass.

## Evidence digests

- `direct-make-lint-c9619cb761.log`:
  `13483e75e18b024563a58ac65ad00f1cb5d7d76fa8769e8beb7d0fc9a3692a55`
- `rtl-verilator-c9619cb761-results.hjson`:
  `f28be58438cbe300dbf973d8fd62dee77c1c56ddd2f0d778037c92ecb2a6d50e`
- `dv-verible-c9619cb761-results.hjson`:
  `d190f411eea5b783a51d963ff83a9aa99313cec71546dc714b0357ac260e4926`
- `xsim-footprint-c9619cb761.log`:
  `52f02128215b6b2a64bd1e53c8c38b6748af75b3d48608a8dfd46a128613787e`
- `vivado-env-c9619cb761/swb-tool-run.json`:
  `7c4ae62b1b64198a0b2d1e61456b0b6f588353731fa3b89cdc051539df594b33`
- `vivado-env-c9619cb761/vivado-env.json`:
  `43c11797bef921b9814fdfda8eeeed3269c51f45b30f082fe84a28266faaed10`

## Claim boundary

These checks support only the requested checkpoint statement: the candidate
implements an overflow-safe DMA memory-footprint check, applies configuration
validation before all DMA request classes, and passes the recorded static and
focused XSim checks.

They do not support a full UVM, regression, coverage, formal, synthesis/QoR,
integration, timing, silicon, or promotion claim.
