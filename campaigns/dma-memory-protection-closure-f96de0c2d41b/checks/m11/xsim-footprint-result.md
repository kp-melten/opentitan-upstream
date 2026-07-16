# Focused DMA Footprint XSim Result

Date: 2026-07-15 America/Chicago
Tool: Vivado Simulator 2025.2.1
Result: pass (`DMA_FOOTPRINT_XSIM_PASS checks=44`)
Raw log: `raw-xsim-tb-log.txt`
Raw log SHA-256: `1ceeecb8293c34f22f3ca50ba03fec71428f2436891e2a9234e8a2fd9a539eda`

Command:

```text
campaigns/dma-memory-protection-closure-f96de0c2d41b/swb-support/checks/run_dma_footprint_xsim.sh campaigns/dma-memory-protection-closure-f96de0c2d41b/checks/m11/final-xsim
```

The check compiles the repository DMA RTL and directly exercises the centralized
footprint functions for exact inclusive limits, one-byte range escapes, low-32-bit
wraparound, fixed wrapped, incrementing wrapped, incrementing non-wrapped, and
fixed-within-chunk non-wrapped addressing, all supported widths, aligned full-word
source reads, and byte-enabled destination writes. It also forces complete static
register/control aggregates at `DmaAddrSetup` and confirms direction-appropriate
address errors or size errors, transition to `DmaError`, and no asserted host, CTN,
or System DMA data request for four rejected configurations.

The runner defines `SYNTHESIS=1` because XSim does not accept OpenTitan assertion
implication syntax. This disables repository assertions; the no-request result is a
campaign-local procedural structural check. It is not a full UVM execution, regression,
coverage result, formal proof, or supported-simulator replacement for
`dma_mem_boundary_vseq`.
