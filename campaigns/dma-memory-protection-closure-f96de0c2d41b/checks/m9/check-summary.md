# M9 Infrastructure and Simulation Probe Check Summary

Date: 2026-07-15
Base campaign commit: `7b9c77ba5b921c203f0d5df6f42dae5b0db57ac1`

## Infrastructure added

### Runtime lock and MCP bundle

- `runtime-lock.json`: Pins swb_runtime_digest, mcp_bundle_hash, campaign/support-profile identity, module implementation identity, source identity, and visibility policy for claim-bearing dispatch.
- `mcp-bundle.json`: Created from `design-knowledge@388e89f3d71ff4e2dda39ea9fb8cc2e1f401a344`. Bundle hash: `swb-mcp-bundle/v0@sha256:c8e0e921a9e92264697b325cf1aa681fe04aa33c3c2afbd35e7ff9d86d8f7cef`.
- `runtime-lock.json` validates against the bundle with `bundle_consistency_status: checked` and `status: ok`.
- Runtime lock hash: `swb-runtime-lock/v0@sha256:69d3899ee65e159352fc75dafa3732915c2d8b7733c8c6380b14e07e12661af6`.

### Launch authority

- `launches/launch-2026-07-15-dma-mem-boundary/launch-authority.json` generated from the runtime lock and MCP bundle. Records accepted_runtime_lock_hash, expected_swb_runtime_digest, required_runtime_capabilities, and authority boundary.

## Xilinx tool probe

- `xvlog` (2025.1.0) and `xsim` (2025.1.0) installed at `/data/tools/Xilinx/2025.1/Vivado/bin/`.
- Vivado is a **simulation-only** install: no FPGA device parts are available, preventing project creation and RTL compilation via Vivado TCL.
- OpenTitan dvsim does not include a `vivado.hjson` profile; supported simulators are xcelium, vcs, questa, riviera, verilator.
- The Verilator dvsim profile has a `run_dir` conflict with `common_sim_cfg.hjson` in this environment, blocking directed simulation.

## Simulation status

- `dma_mem_boundary` directed simulation: **pending** on this environment.
  - Xcelium: `xrun` not installed.
  - Vivado: no FPGA parts, no dvsim profile.
  - Verilator dvsim: run_dir conflict.
- This is the same status as M8: explicitly recorded pending, not implicitly passing.

## Claim boundary

Supported implementation-checkpoint claim:

- Runtime lock, MCP bundle, and launch authority are committed and validated.
- The DMA RTL/DV implementation from C2 is unchanged (33-bit inclusive footprint checks + explicit-width cleanup).
- DMA Verilator lint passes (zero flow errors, lint warnings, lint errors per M8).
- Xilinx tools exist but cannot be used for dvsim-based directed simulation on this host.

Non-claims:

- No behavioral simulation pass or no-request dynamic proof.
- No full regression, coverage closure, formal proof, integration, synthesis, timing, silicon, or promotion claim.
- Directed simulation remains pending, not implicitly passing.
