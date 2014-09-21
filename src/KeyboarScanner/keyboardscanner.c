#include <avr/io.h>
#include "keyboardscanner.h"

uint8_t *scan_keyboard(uint8_t scancode[4])
{
  // Initlalise the scancode
  scancode[0] = 0x10;
  scancode[1] = 0x20;
  scancode[2] = 0x40;
  scancode[3] = 0x80;

  // Initialise the port and data direction
  KEYBOARD_DDR = 0x10;    // data direction: output
  KEYBOARD_PORT = 0x0F;   // set pull up's

  uint8_t i = 0x00;
  for(i = 0; i < 4; i++)
  {
    scancode[i] |= KEYBOARD_PIN;
    KEYBOARD_DDR *= 2;
  }

  return scancode;
}
