# IP Repository

This repository contains the IP cores that I have written or modified.

The following is a list of the cores currently available:

- [packet_generator](packet_generator): This core adds a TLAST signal to an
  AXI-STREAM interface, which is useful for linking it to DMA. Some options,
  such as the size of the packet, are configurable via an AXI-LITE interface.
  The core is a modified version of the one distributed by
  [strath-sdr](https://github.com/strath-sdr/pynq_nco/tree/main).
