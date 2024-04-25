"""PYNQ driver for numerically controlled oscillator."""

from typing import NewType

from pynq import DefaultIP

BitLike = NewType("BitLike", int)
"""Can be 0 or 1."""

_SAMPLE_FREQUENCY = 100e6
_PHASE_WIDTH = 16


class NumericalOscillator(DefaultIP):
    """A class to control an NCO IP Core."""

    bindto = ["unimib.it:user:nco:1.0"]

    def __init__(self, description):
        """Create a Numerical Oscillator object that controls the NCO IP Core in the PL."""
        super().__init__(description=description)
        self.frequency = 1e6
        self.real_enable()

    @property
    def _control(self) -> BitLike:
        return self.read(0x00)

    @_control.setter
    def _control(self, value: BitLike):
        self.write(0x00, value)

    @property
    def _phase(self):
        return self.read(0x04)

    @_phase.setter
    def _phase(self, value: int):
        self.write(0x04, value)

    @property
    def _gain(self) -> int:
        return self.read(0x08)

    @_gain.setter
    def _gain(self, value: int):
        self.write(0x08, value)

    @property
    def frequency(self) -> float:
        """The output frequency of the NCO."""
        reg = self._phase * (2**-16)
        return (_SAMPLE_FREQUENCY * reg) / (2**_PHASE_WIDTH)

    @frequency.setter
    def frequency(self, value):
        """Set the desired frequency of the NCO."""
        if not (0 < value < _SAMPLE_FREQUENCY / 2):
            raise ValueError(
                f"Select a frequency between 1 and {self._SAMPLE_FREQUENCY}"
            )
        reg = (value * (2**_PHASE_WIDTH)) / _SAMPLE_FREQUENCY
        self._phase = int(reg * (2**16))

    @property
    def gain(self):
        """The output gain of the NCO."""
        return self._gain * (2**-30)

    @gain.setter
    def gain(self, value):
        """Set the NCO gain."""
        if (value > 1) or (value < -1):
            raise ValueError("Select a gain between -1 and 1")
        self._gain = int(value * (2**30))

    def enable(self):
        """Enables the Cosine and Sine wave output of the NCO."""
        reg = self._control
        reg |= 0x00000001
        self._control = reg

    def disable(self):
        """Disables the Cosine and Sine wave output of the NCO."""
        reg = self._control
        reg &= 0xFFFFFFFC
        self._control = reg
