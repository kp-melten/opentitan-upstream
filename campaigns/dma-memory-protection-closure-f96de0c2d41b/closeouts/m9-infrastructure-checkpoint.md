# M9 Infrastructure Implementation Checkpoint

Generated local: 2026-07-15 America/Chicago
Posture: implementation_checkpoint
Milestone: M7 remains pending

## Delta

Established the complete campaign launch infrastructure required for claim-bearing work and probed Xilinx tool availability per campaign spec.

### Infrastructure committed

1. **runtime-lock.json** — Pins SWB runtime digest (`sha256:b02f5a3a…`), MCP bundle hash, campaign identity, module implementation identity (`swb-knowledge-module`/`knowledge-module-behavior/v0`), source identity (`design-knowledge@388e89f3…`), and visibility policy. Validates against bundle with `bundle_consistency_status: checked`.
2. **mcp-bundle.json** — Generated from `design-knowledge@388e89f3d71ff4e2dda39ea9fb8cc2e1f401a344`. Bundle hash: `swb-mcp-bundle/v0@sha256:c8e0e921a9e92264697b325cf1aa681fe04aa33c3c2afbd35e7ff9d86d8f7cef`.
3. **launch-authority.json** — Generated via `swb campaign launch-authority`. Accepts runtime lock hash `swb-runtime-lock/v0@sha256:69d3899ee65e159352fc75dafa3732915c2d8b7733c8c6380b14e07e12661af6`. Records `human_controller` as recorded-by with authority boundary.
4. **evidence/** directory created for future campaign evidence artifacts.

### Xilinx tool probe

`xvlog` (2025.1.0) and `xsim` (2025.1.0) installed at `/data/tools/Xilinx/2025.1/Vivado/bin/`. Vivado is a simulation-only install with no FPGA parts, preventing project-based RTL compilation. OpenTitan dvsim lacks a `vivado.hjson` profile.

## Evidence changed

- Added `checks/m9/check-summary.md`
- Added `checks/m9/xilinx-probe.md`
- Added `campaigns/dma-memory-protection-closure-f96de0c2d41b/runtime-lock.json`
- Added `campaigns/dma-memory-protection-closure-f96de0c2d41b/mcp-bundle.json`
- Added `campaigns/dma-memory-protection-closure-f96de0c2d41b/launches/launch-2026-07-15-dma-mem-boundary/launch-authority.json`

## Result

Campaign launch infrastructure is complete and validated. Runtime lock, MCP bundle, and launch authority are committed and consistent. DMA Verilator lint passes (zero diagnostics, per M8). Directed simulation remains pending on this environment.

## Claim boundary

Implementation-checkpoint only: the campaign has the complete runtime lock, MCP bundle, and launch authority ready for claim-bearing dispatch. The candidate implements the DMA footprint closure work and clears the local generated Verilator lint diagnostics.

No behavioral simulation pass, no-request dynamic proof, full regression, coverage closure, formal proof, integration, backend, silicon, or promotion claim is made.

## Next action

Obtain human silicon architect sign-off and DV-owner sign-off on `initial-packet.md` for promotion-eligible claim, then submit for M7 independent review and promotion.
