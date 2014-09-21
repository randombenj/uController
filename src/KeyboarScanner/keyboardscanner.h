#ifndef KEYBOARDSCANNER_H_
#define KEYBOARDSCANNER_H_

#define KEYBOARD_PORT PORTB
#define KEYBOARD_PIN  PINB
#define KEYBOARD_DDR  DDRB

/**
 * Scans the matrix keyboard for pressed
 * switches.
 * @param scancode
 *  Data container for the scancode to store in
 * @return
 *  Returns the scan code of the keyboard (reference to param scancode)
 */
uint8_t *scan_keyboard(uint8_t scancode[4]);

#endif // KEYBOARDSCANNER_H_
