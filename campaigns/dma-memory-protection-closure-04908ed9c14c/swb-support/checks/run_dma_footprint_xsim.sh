#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <campaign-check-output-directory>" >&2
  exit 2
fi

repo_root=$(git rev-parse --show-toplevel)
campaign_rel=campaigns/dma-memory-protection-closure-04908ed9c14c
case "$1" in
  /*) out_dir=$1 ;;
  *)  out_dir=$repo_root/$1 ;;
esac

allowed_root=$repo_root/$campaign_rel/checks/
case "$out_dir/" in
  "$allowed_root"*) ;;
  *)
    echo "output must be below $allowed_root" >&2
    exit 2
    ;;
esac

if [[ -e "$out_dir" ]] && [[ -n "$(find "$out_dir" -mindepth 1 -maxdepth 1 -print -quit)" ]]; then
  echo "output directory must be absent or empty: $out_dir" >&2
  exit 2
fi

xilinx_bin=${XILINX_VIVADO_BIN:-/data/tools/Xilinx/2025.2.1/Vivado/bin}
for tool in xvlog xelab xsim; do
  if [[ ! -x "$xilinx_bin/$tool" ]]; then
    echo "required Xilinx tool not executable: $xilinx_bin/$tool" >&2
    exit 2
  fi
done
command -v fusesoc >/dev/null

mkdir -p "$out_dir"
cd "$repo_root"
fusesoc --cores-root . run \
  --target=lint \
  --tool=xsim \
  --setup \
  --no-export \
  --work-root "$out_dir" \
  lowrisc:ip:dma:0.1

cd "$out_dir"
"$xilinx_bin/xvlog" \
  --prj lowrisc_ip_dma_0.1.prj \
  -i "$repo_root/hw/ip/prim/rtl" \
  --define SYNTHESIS=1 \
  --log xvlog-deps.log
"$xilinx_bin/xvlog" \
  --sv "$repo_root/$campaign_rel/swb-support/checks/dma_footprint_xsim_tb.sv" \
  -i "$repo_root/hw/ip/prim/rtl" \
  --define SYNTHESIS=1 \
  --log xvlog-tb.log
"$xilinx_bin/xelab" dma_footprint_xsim_tb \
  --snapshot dma_footprint_xsim_tb \
  -i "$repo_root/hw/ip/prim/rtl" \
  --define SYNTHESIS=1 \
  --log xelab-tb.log
"$xilinx_bin/xsim" dma_footprint_xsim_tb -R --log xsim-tb.log

# XSim returns success even when a SystemVerilog $fatal terminates the testbench.
# Treat the testbench's explicit completion marker as the authoritative result.
if ! grep -q '^DMA_FOOTPRINT_XSIM_PASS ' xsim-tb.log; then
  echo "XSim footprint check did not report its pass marker" >&2
  exit 1
fi
