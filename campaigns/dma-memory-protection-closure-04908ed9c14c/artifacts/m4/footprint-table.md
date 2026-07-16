# DMA Address Footprint Derivation

The enabled OT memory range uses inclusive `base` and `limit` addresses. For a
nonzero write footprint, the final accessed byte is calculated in 33 bits as
`{1'b0, start} + footprint_size - 1`; carry into bit 32 is rejected for OT and
CTN endpoints.

Let `N=total_data_size`, `C=chunk_data_size`, and `W` be the transfer width in
bytes. Valid multi-chunk configurations require every non-final chunk to be an
integer multiple of `W`.

| Addressing | `increment` | `wrap` | Destination write envelope length |
| --- | ---: | ---: | ---: |
| Incrementing, non-wrapped | 1 | 0 | `N` |
| Incrementing, chunk-wrapped | 1 | 1 | `min(N,C)` |
| Fixed, wrapped | 0 | 1 | `min(W,N,C)` |
| Fixed within each non-wrapped chunk | 0 | 0 | `O + min(W,N-O)`, where `O=floor((N-1)/C)*C` |

The last row is a sparse reachable set: one transfer-width request at each
chunk start. A contiguous envelope ending at the last reachable byte is exact
for checking containment in one contiguous enabled region.

OT source reads use `tlul_adapter_host`, which emits an aligned full-word Get
even for one- and two-byte logical widths. Their physical first byte is
`align_down_4(start)`, and the physical last byte is the final request word's
aligned address plus three. Destination writes use only their asserted byte
lanes.

The range restriction applies across the OT boundary:

- restricted source: OT internal to CTN or System;
- restricted destination: CTN or System to OT internal;
- OT-to-OT is not range-restricted by this mechanism.

This derivation is source inspection, not runtime evidence. Variable division
in the sparse-envelope helper remains a synthesis/QoR review item.
