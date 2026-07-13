# M7 Corrected-Candidate Check Summary

Date: 2026-07-13
Candidate commit: `aaf13e1aa2c36681596fc2393acdebfda7b2db29`
Campaign branch: `campaign/dma-memory-protection-closure-f96de0c2d41b`

## Corrective source delta

Independent source review found that the earlier candidate modeled narrow TL-UL reads as
byte-lane accesses even though `tlul_adapter_host` emits an aligned full-word Get. It also
did not reject low-32-bit wrap on the non-restricted CTN side. Candidate C1 corrects both
surfaces: source validation covers the complete aligned read word, destination validation
follows enabled write lanes, and OT/CTN source and destination footprints reject carry into
address bit 32. The directed sequence now contains 23 cases, including the narrow-read
escape, both CTN wrap directions, and partial-final 2B/4B transfers.

## DMA DV Verible lint

Command:

```text
dvsim hw/top_darjeeling/lint/top_darjeeling_dv_lint_cfgs.hjson --tool veriblelint --local --purge --select-cfgs dma --scratch-root <temporary-check-root>
```

Result: pass at candidate commit C1, with zero flow warnings, flow errors, lint warnings,
or lint errors. Parsed result: `dv-verible-results.hjson`.

## DMA Verilator lint target

Command:

```text
PATH=<verilator-4.210-prebuilt>/bin:$PATH dvsim hw/top_darjeeling/lint/top_darjeeling_lint_cfgs.hjson --tool verilator --local --purge --select-cfgs dma --scratch-root <temporary-check-root>
```

Tool: project-container default Verilator 4.210 prebuilt, binary SHA-256
`07d99dcc47740bad8e99ab7349f3d0e88ae4e4793de53fcc619d3de957367585`.

Result: nonzero exit; one flow warning, two flow errors, 29 lint warnings, and zero lint
errors. The fatal diagnostic remains the base-reproducible width warning at
`prim_diff_decode.sv:162`; no warning points into the new footprint functions, and the
candidate has the same DMA warning count as the recorded base run. The hard lint-pass gate
remains pending. Parsed result: `rtl-verilator-results.hjson`.

## Directed boundary simulation

Command:

```text
dvsim hw/ip/dma/dv/dma_sim_cfg.hjson --items dma_mem_boundary --reseed 1 --local --purge --scratch-root <temporary-check-root>
```

Result: unavailable/pending. DVSim recognized the corrected test and generated the Xcelium
build, but `xrun` is absent; compilation and simulation did not occur, simulated time was
0.000 us, and no behavioral result is claimed. Parsed report:
`directed-xcelium-report.json`.

## Source review

The independent verifier re-reviewed the corrected RTL/model/test delta and found the two
prior high-severity source issues addressed with no new RTL/model mismatch in the reviewed
scope. This supports a narrowed source-alignment claim only. The verifier record is
`../../verifier/m7/result.md`.

## Remaining verification

- Obtain a project-policy resolution for the base `prim_diff_decode.sv` diagnostic and a
  zero-exit DMA Verilator target.
- Compile and run `dma_mem_boundary` with Xcelium or another accepted supported simulator.
- Obtain required silicon-architect and DV-owner sign-offs before promotion.
- Run any accepted broader DMA regression/coverage work; none is claimed here.
