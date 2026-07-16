# M6 DMA Memory-Protection Checks

Date: 2026-07-16 America/Chicago
Candidate base: `58f8fdd5396817b775d2c69af9a6322ac7a84e5a`
Worktree: dirty implementation checkpoint

## Static checks

- DMA DV Verible lint passed with zero flow warnings/errors and zero lint
  warnings/errors:
  `dv-verible-results.hjson`.
- DMA Verilator generated results contain zero flow errors and zero lint
  warnings/errors. The DVSim wrapper exits nonzero solely because it promotes
  the Edalize backend deprecation warning.
- The generated DMA `lint-only` target was therefore run directly and exited
  successfully:
  `direct-make-lint.log`.

The first fresh Verilator attempt exposed a baseline width warning in
`prim_diff_decode`. The candidate includes a behavior-preserving typed-width
cleanup for its skew counter; the rerun has no lint errors.

## Xilinx checks

`swb tool run vivado-env` passed and recorded Vivado Simulator 2025.2.1 plus
the resolved `xvlog`, `xelab`, and `xsim` tools under `vivado-env/`.

The focused XSim helper passed:

```text
DMA_FOOTPRINT_XSIM_PASS checks=44
```

It checks the centralized footprint functions, inclusive bounds, physical
source-read footprints, sparse fixed/non-wrapped envelopes, overflow cases,
and the `DmaAddrSetup` error/no-data-request path.

The full `lowrisc:dv:dma_sim:0.1` project was generated and elaboration was
attempted with XSim's UVM 1.2 library. It stopped in common OpenTitan `sec_cm`
code because XSim requires a `value` argument on `uvm_hdl_release`:

```text
ERROR: [VRFC 10-3638] port 'value' is not connected on function call 'uvm_hdl_release'
```

The full `dma_mem_boundary` UVM sequence is therefore pending, not passing.
`xrun` was not present on PATH.

## Evidence digests

- `direct-make-lint.log`:
  `ecdf512e416e7eb5203b3da17ac0fbc6d1cbf6dc6e61a0853764e77dd7b3d767`
- `rtl-verilator-results.hjson`:
  `f28be58438cbe300dbf973d8fd62dee77c1c56ddd2f0d778037c92ecb2a6d50e`
- `dv-verible-results.hjson`:
  `d190f411eea5b783a51d963ff83a9aa99313cec71546dc714b0357ac260e4926`
- `xsim-tb.log`:
  `b6a8827914c0624555cda4671eb796b0f3fb2443e83770187aa45096cda718c5`
- `uvm-xsim-build.log`:
  `70345f7c00e9850dddbabca1099a170c4567b998a753bf338d8c4ab7b7b9376c`

## Claim boundary

These checks support an implementation-checkpoint claim that the candidate
implements the reviewed footprint logic, the generated DMA Verilator lint
target exits successfully, DMA DV lint is clean, and the focused XSim helper
passes.

They do not support a full UVM, clocked multi-chunk scoreboard, strict
all-external-request suppression, regression, coverage, formal, synthesis/QoR,
integration, timing, silicon, or promotion claim.
