
# -----------------------------------------------------------------------------
#
#    Quintus Quadratus - Munching Square on RISC-V for Lovebyte 2023
#    Copyright (C) 2023  Matthias Koch & Robert Clausecker
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

.option norelax
.option rvc

# -----------------------------------------------------------------------------
#  Peripheral IO registers
# -----------------------------------------------------------------------------

  .equ RCU_BASE,     0x40021000
  .equ RCU_APB1EN,        0x01C

  .equ DAC_BASE,     0x40007000
  .equ DAC_CTL,           0x400
  .equ DACC_R12DH,        0x420

# -----------------------------------------------------------------------------
Reset:
# -----------------------------------------------------------------------------

  li x14, RCU_BASE
  li x3,  DAC_BASE
  li x15, 0x00010001

mainloop:
  li x8,  -8
  sw x8,  RCU_APB1EN(x14) # Enable DAC and most of everything else
  sw x15, DAC_CTL(x3)     # Enable both DAC channels by setting DEN0 and DEN1

# -----------------------------------------------------------------------------
#  Notes on register usage:
#
#   x3: Constant DAC_BASE
#
#   x8: -1
#   x9: Pixel
#
# -----------------------------------------------------------------------------

  add  x8, x8, x9
  slli x9, x9, 16
  xor  x9, x9, x8

  sw x9, DACC_R12DH(x3)
  j mainloop

# -----------------------------------------------------------------------------
# signature: .byte 'M', 'e', 'c', 'r', 'i', 's', 'p', '&', 'F', 'u', 'z'
# -----------------------------------------------------------------------------
