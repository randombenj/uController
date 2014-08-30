#ifndef LCD_H_
#define LCD_H_

//------------------------------------------------------------
// FUNCTION SET:
//------------------------------------------------------------
//  RS | R/W | DB7 | DB6 | DB5 | DB4 | DB3 | DB2 | DB1 | DB0 |
//------------------------------------------------------------
//  0  |  0  |  0  |  0  |  1  |  DL |  N  |  F  |  -  |  -  |
//------------------------------------------------------------
// DL: interface data length control bit (4 bit mode)
// N:  line number (2 line)
// F:  font type (5x8 bit)
#define    FUNCTION_SET  = 0x28

//------------------------------------------------------------
// ENTRY MODE SET:
//------------------------------------------------------------
//  RS | R/W | DB7 | DB6 | DB5 | DB4 | DB3 | DB2 | DB1 | DB0 |
//------------------------------------------------------------
//  0  |  0  |  1  |  0  |  0  |  0  |  0  |  1  | I/D |  SH |
//------------------------------------------------------------
// I/D: increment / decrement of DDRAM address (move to right)
// SH:  shift of entire display (no shift)
//
// Entry mode set means that,
// when writing the cursor moves to the
// right.
//
// We want to increment the cursor
// (move to the right when writing)
// and not shift the display.
#define    ENTRYMODE_SET = 0x06

//------------------------------------------------------------
// LCD ON / CURSOR ON:
//------------------------------------------------------------
//  RS | R/W | DB7 | DB6 | DB5 | DB4 | DB3 | DB2 | DB1 | DB0 |
//------------------------------------------------------------
//  0  |  0  |  0  |  0  |  0  |  0  |  1  |  D  |  C  |  B  |
//------------------------------------------------------------
// turn LCD/Cursor/blink On or Off (raw command)
// D: display on/off
// C: cursor on/off
// B: cursor blink on/off (off)
#define    LCD_CTRL_RAW  = 0x08  // raw command (all off)
#define    LCD_CTRL_CUR  = 0x0A  // raw command (cursor on)
#define    LCD_CTRL_LCD  = 0x0C  // raw command (lcd on)

//------------------------------------------------------------
// CLEAR THE LCD:
//------------------------------------------------------------
//  RS | R/W | DB7 | DB6 | DB5 | DB4 | DB3 | DB2 | DB1 | DB0 |
//------------------------------------------------------------
//  0  |  0  |  0  |  0  |  0  |  0  |  0  |  0  |  0  |  1  |
//------------------------------------------------------------
// writes 0x20 ' ' (space) to all DDRAM addresses and return
// cursor home (address: 0x00)
#define    CLEAR_LCD  = 0x01

//------------------------------------------------------------
// SET DDRAM ADDRESS:
//------------------------------------------------------------
//  RS | R/W | DB7 | DB6 | DB5 | DB4 | DB3 | DB2 | DB1 | DB0 |
//------------------------------------------------------------
//  0  |  0  |  1  | AC6 | AC5 | AC4 | AC3 | AC2 | AC1 | AC0 |
//------------------------------------------------------------
// set display data ram address (raw command)
#define    SET_DDRAM     = 0x80

/**
* Initialise the LCD
*
* This routine is used to Initialise the LCD,
* it must be called first to use the LCD
*/
void lcd_init();

/**
 * Turns the LCD on
 */
void lcd_on();

/**
 * Turns the LCD off
 */
void lcd_off();

/**
 * Turns the cursor on the LCD off
 */
void lcd_cursor_off();

/**
 * Turns the cursor on the LCD on
 */
void lcd_cursor_on();

/**
 * Sets the cursor position on the LCD
 * @param x
 *   The X coordinates of the cursor on the LCD
 * @param y
 *   The Y coordinates of the cursor on the LCD
 */
void lcd_set_position(int x, int y);

/**
 * Puts a character on the LCD
 * @param character
 *   Character to put on LCD
 */
void lcd_char(char character);

/**
 * Put a String to the LCD
 * @param string
 *  String to put on LCD
 */
void lcd_string(char string[]);

#endif // LCD_H_
