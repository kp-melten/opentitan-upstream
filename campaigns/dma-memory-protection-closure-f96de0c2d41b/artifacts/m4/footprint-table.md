# DMA Address Footprint Derivation

The enabled OT memory range uses inclusive `base` and `limit` addresses. For a nonzero
footprint, the final accessed byte is computed in 33 bits as
`{1'b0, start} + footprint_size - 1`. A set 33rd bit is a 32-bit address-space wrap and
is rejected.

The table below is derived from the `DmaAddrSetup` address selection and byte-enable
generation in `hw/ip/dma/rtl/dma.sv`.

| Documented mode | `increment` | `wrap` | Reachable byte span from start |
| --- | ---: | ---: | --- |
| Fixed address | 0 | 1 | `min(transfer_width_bytes, chunk_data_size, total_data_size)` |
| Incrementing, chunk wrapped | 1 | 1 | `min(chunk_data_size, total_data_size)` |
| Incrementing, non-wrapped | 1 | 0 | `total_data_size` |

The non-wrapped result covers all chunks because the live address continues from the
previous transaction rather than reloading at each chunk. The chunk-wrapped result
reloads the programmed start address at each chunk boundary. Fixed mode reloads the
programmed start address for each transaction, so only the active one-, two-, or
four-byte lane span is reachable.

The undocumented `increment=0, wrap=0` combination has legacy chunk-stepped behavior in
the address CSR update path. The candidate conservatively validates its complete
`total_data_size` span. The campaign capability and directed matrix cover the three
documented modes above.

For TL-UL requests the bus address is word aligned, but only byte-enable lanes are
accessed. Scoreboard range checking therefore validates every asserted byte-enable lane
against the inclusive range rather than treating the aligned request address as the
complete access.
