# M13 DMA Memory-Protection Verification Refresh

Date: 2026-07-16 America/Chicago
Candidate commit: `aa65a4449255400d7158098549959825048cb580`
Worktree state at check start: clean

## Technical Audit

The C4 footprint implementation was rechecked against the RTL address and chunk
state transitions. No new source-level correctness blocker was found:

- incrementing non-wrapped endpoints validate the complete remaining transfer;
- incrementing wrapped endpoints validate the reachable chunk;
- fixed wrapped endpoints validate only the repeated request;
- fixed non-wrapped endpoints validate the exact sparse envelope formed by the
  current and later chunk starts;
- source-side validation includes each aligned four-byte TL-UL Get footprint;
- destination-side validation follows the byte-enabled write footprint;
- partial non-final chunks that would skip bytes are rejected in
  `DmaAddrSetup` before a source or destination data request.

The variable division used to derive the fixed non-wrapped sparse envelope
remains a synthesis/QoR review item. This refresh does not add a synthesis,
timing, or area claim.

## Static Checks

DMA DV Verible lint completed with zero flow warnings/errors and zero lint
warnings/errors.

DMA RTL Verilator generated results contain zero flow errors and zero lint
warnings/errors. The DVSim wrapper exits nonzero only because it promotes the
known Edalize backend deprecation warning. The generated DMA `lint-only` target
was therefore run directly and exited 0.

Commands:

```text
dvsim hw/top_darjeeling/lint/top_darjeeling_lint_cfgs.hjson --tool verilator --local --purge --select-cfgs dma --scratch-root campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m13/rtl-verilator
make -C campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m13/rtl-verilator/campaign-dma-memory-protection-closure-f96de0c2d41b/dma-lint-verilator/default/fusesoc-work lint-only
dvsim hw/top_darjeeling/lint/top_darjeeling_lint_cfgs.hjson --tool veriblelint --local --purge --select-cfgs dma --scratch-root campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m13/dv-verible
```

## Xilinx Simulation

The campaign-local focused XSim runner passed on Vivado Simulator 2025.2.1:

```text
DMA_FOOTPRINT_XSIM_PASS checks=44
```

The full `lowrisc:dv:dma_sim:0.1` project was also generated for XSim and built
with Xilinx's precompiled UVM 1.2 library plus the normal OpenTitan UVM defines.
Compilation advanced into the OpenTitan sec_cm interfaces, then stopped because
XSim requires a `value` argument on `uvm_hdl_release` while the OpenTitan calls
use the standard one-argument form:

```text
ERROR: [VRFC 10-3638] port 'value' is not connected on function call 'uvm_hdl_release'
```

The full `dma_mem_boundary` UVM sequence therefore remains unavailable on this
XSim installation without out-of-scope common-DV compatibility changes. This is
recorded as pending, not passing.

## Evidence Digests

- `direct-make-lint.txt`: `2d27322cf94075ab9eaf7f7d160f09fd9e6d98413933c43a0b40d613cdf62218`
- `dv-verible-log.txt`: `ceda0a7b09d76fa4ea9a1980744858ffe1598eac0c0fd67328403735efc9ca68`
- `dv-verible-results.hjson`: `d190f411eea5b783a51d963ff83a9aa99313cec71546dc714b0357ac260e4926`
- `rtl-verilator-log.txt`: `0d57479eaadffc8b067534f9382cf5b2d1f1baad378c46c7082ec24404b0e4ba`
- `rtl-verilator-results.hjson`: `f28be58438cbe300dbf973d8fd62dee77c1c56ddd2f0d778037c92ecb2a6d50e`
- `uvm-xsim-build.txt`: `fe45588f91109c86b98167b31d691ba3c9a61e56b911bf5b6c1678d46de6a64d`
- `xsim-tb-log.txt`: `346aed234150d8c05613856aaaf7e05446e40948418306e23c6aa2df4a26d74a`

## Claim Boundary

This refresh supports the existing implementation-checkpoint claim: the
candidate implements the reviewed overflow-safe footprint logic, the generated
DMA Verilator lint target exits successfully, DV Verible lint is clean, and the
focused 44-check XSim test passes.

It does not support a full UVM, clocked multi-chunk scoreboard, full
bus-monitor no-request, regression, coverage, formal, synthesis/QoR,
integration, timing, silicon, or promotion claim.
