# Candidate Ledger

Record every candidate base and promotion-relevant source identity here.

| Candidate ID | Base Ref / Commit | Implementation Commit | Measurement Anchors | Status | Claims | Non-Claims |
| --- | --- | --- | --- | --- | --- | --- |
| C0 | `origin/master` / `58f8fdd5396817b775d2c69af9a6322ac7a84e5a` | `4c0b71ccc9085482e9ebbac53dfef2f37d194fdb` | `artifacts/m4/footprint-table.md`; `checks/m6/check-summary.md` and raw result files | implementation-checkpoint | Candidate implements centralized 33-bit inclusive-footprint checks plus aligned directed DV; DV Verible lint passed | DMA Verilator target pass and directed simulation pass remain pending; no full regression, coverage, formal, integration, backend, silicon, or promotion claim |
| C1 | `origin/master` / `58f8fdd5396817b775d2c69af9a6322ac7a84e5a` | `aaf13e1aa2c36681596fc2393acdebfda7b2db29` | `artifacts/m4/footprint-table.md`; `checks/m7/check-summary.md`; `verifier/m7/result.md` | implementation-checkpoint; source-reviewed | Candidate validates aligned full-word source reads, byte-enabled destination writes, and OT/CTN 32-bit wrap; independent focused source review found the prior high findings corrected; DMA DV Verible lint passed | DMA Verilator target exits nonzero on a base-reproducible primitive warning; directed simulation is unavailable; no behavioral, no-request dynamic proof, regression, coverage, formal, integration, backend, silicon, or promotion claim |
