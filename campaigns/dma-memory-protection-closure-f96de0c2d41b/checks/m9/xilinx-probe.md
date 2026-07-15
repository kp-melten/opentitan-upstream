# Xilinx Tool Probe (2026-07-15)

**Purpose**: Verify Xilinx toolchain availability per campaign spec ("Xilinx tools (e.g. xvlog, etc.) are available for simulation. Be sure to utilize.")

## Installed Tools

| Tool | Path | Version | Available |
| --- | --- | --- | --- |
| `xvlog` | `/data/tools/Xilinx/2025.1/Vivado/bin/xvlog` | 2025.1.0 | Yes |
| `xsim` | `/data/tools/Xilinx/2025.1/Vivado/bin/xsim` | 2025.1.0 | Yes |
| `vivado` | `/data/tools/Xilinx/2025.1/Vivado/bin/vivado` | 2025.1.0 | Yes |

## FPGA Part Availability

No FPGA device parts are installed. The Vivado install is a **simulation-only** configuration. Vivado project creation fails because no part can be resolved:

    WARNING: [Device 21-436] No parts matched 'xc7a35tcpg236-1'
    ERROR: [Coretcl 2-106] Specified part could not be found.

## DVSim Compatibility

OpenTitan's `dvsim` does not include a `vivado.hjson` profile. The supported simulators are: xcelium, vcs, questa, riviera, verilator.

## Conclusion

Xilinx tools are installed but unsuitable for OpenTitan's dvsim-based UVM simulation flow: no FPGA parts means Vivado synthesis/compilation projects cannot be created; no vivado.hjson means dvsim cannot route to Xilinx tools.

Record dma_mem_boundary directed simulation as pending for this environment.
