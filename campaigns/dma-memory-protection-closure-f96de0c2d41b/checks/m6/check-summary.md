# M6 Focused Check Summary

Date: 2026-07-13
Candidate base: `58f8fdd5396817b775d2c69af9a6322ac7a84e5a`
Implementation commit: `4c0b71ccc9085482e9ebbac53dfef2f37d194fdb`
Campaign branch: `campaign/dma-memory-protection-closure-f96de0c2d41b`

The focused commands ran against the campaign working tree rooted at packet commit
`ef6996d7d083ec4b40c456a503d710976cb415fa`. The tested RTL and DV collateral was then
committed without intervening source changes as the implementation commit above. The raw
dvsim report therefore names the pre-commit root while this ledger records the durable
candidate identity.

## DMA Verilator lint target

Command:

```text
dvsim hw/top_darjeeling/lint/top_darjeeling_lint_cfgs.hjson --tool verilator --local --purge --select-cfgs dma --scratch-root <campaign-check-root>
```

Tool: Verilator 5.020.

Candidate result: nonzero exit; 1 flow warning, 2 flow errors, 29 lint warnings,
and 0 lint errors. The fatal diagnostic is a `WIDTHEXPAND` warning in
`prim_diff_decode.sv:162`, followed by the lint build exiting with status 2.

A clean detached worktree at the candidate base was run with the same configuration and
tool. It produced the same counts and the same fatal `prim_diff_decode.sv:162`
diagnostic. No warning points into the newly added DMA footprint functions. This is
recorded as a baseline/tool-environment blocker; the hard gate that the target pass is
not claimed.

Raw results:

- `rtl-verilator-candidate-results.hjson`
- `rtl-verilator-baseline-results.hjson`

## DMA DV Verible lint

Command:

```text
dvsim hw/top_darjeeling/lint/top_darjeeling_dv_lint_cfgs.hjson --tool veriblelint --local --purge --select-cfgs dma --scratch-root <campaign-check-root>
```

Result: pass, with zero flow warnings, flow errors, lint warnings, or lint errors. The
new directed sequence is listed in `dma_env.core`, so it is included in this parsed
source set. Raw result: `dv-verible-results.hjson`.

## Directed boundary simulation

Command:

```text
dvsim hw/ip/dma/dv/dma_sim_cfg.hjson --items dma_mem_boundary --reseed 1 --local --purge --scratch-root <campaign-check-root>
```

Result: unavailable/pending. Dvsim recognized the test and generated the build, then the
Xcelium build stopped before compilation or simulation because `xrun` is not installed
(`bash: xrun: command not found`, make exit 127). Simulated time was 0.000 us. This is
not recorded as either a design pass or design failure. Raw report:
`directed-xcelium-report.json`.

## Local source checks

`git diff --check` passed. Dvsim test listing recognizes `dma_mem_boundary`.

## Remaining verification

- Resolve or waive the base-reproducible Verilator `prim_diff_decode.sv` warning under
  the project lint policy, then obtain a passing DMA Verilator target.
- Compile and run `dma_mem_boundary` in an environment with Xcelium available.
- Obtain independent RTL/DV review before any promotion claim.
- Run any accepted broader DMA regression and coverage work; none is claimed here.
