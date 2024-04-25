"""PYNQ driver for packet_generator."""

from typing import NewType

from pynq import DefaultIP

BitLike = NewType("BitLike", int)
"""Can be 0 or 1."""


class PacketGenerator(DefaultIP):
    """PacketGenerator IP driver."""

    bindto = ["unimib.it:user:packet_generator:1.0"]
    _MAX_TRANSFER = 1e7

    @property
    def reset(self) -> BitLike:
        """Read reset bit."""
        return self.read(0x00)

    @reset.setter
    def reset(self, value: BitLike):
        """Write reset bit."""
        self.write(0x00, value)

    @property
    def enable(self) -> BitLike:
        """Read enable bit."""
        return self.read(0x04)

    @enable.setter
    def enable(self, value: BitLike):
        """Write enable bit."""
        self.write(0x04, value)

    @property
    def packetsize(self) -> int:
        """Read set packetsize."""
        return self.read(0x08)

    @packetsize.setter
    def packetsize(self, value: int):
        if not (0 < value <= self._MAX_TRANSFER):
            raise ValueError(
                f"Packet size is  {value}, has to be in [0,{self._MAX_TRANSFER}]"
            )
        self.write(0x08, value)
