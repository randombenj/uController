#ifndef KEYBOARDSCANNER_H_
#define KEYBOARDSCANNER_H_

/**
 * Scans the matrix keyboard for pressed
 * switches.
 * @param port
 *  The port where the matrix keyboard is
 * @return
 *  Returns the scan code of the keyboard
 */
uint8_t scan_keyboard(volatile uint8_t *port, volatile uint8_t *port_ddr);

#endif // KEYBOARDSCANNER_H_
