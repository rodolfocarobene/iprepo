# PacketGenerator

This core is protected by a [BSD 3-Clause License](LICENSE) and is a modified
version of
[this IP](https://github.com/strath-sdr/pynq_nco/tree/main/boards/ip/iprepo/nco).

## Interfaces

- S_AXI_Lite: for configuration purposes
- M_AXIS_REAL: output AXI-stream interface (TDATA, TVALID)
- M_AXIS_IMAG: output AXI-stream interface (TDATA, TVALID)
- aclk: clock used for both AXI_Lite and AXI-stream
- aresetn: reset signal

## PYNQ driver

The IP is correlated with a [PYNQ driver](pynq_driver.py) to control it.
