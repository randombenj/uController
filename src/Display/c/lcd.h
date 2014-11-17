#ifndef LCD_H_
#define LCD_H_

// LCD Port and Data Direction
#define LCD               PORTA
#define LCD_D             DDRA

// ENABLE at port postion 5
#define ENABLE            PA5
// REGISTERSELECT at port position 4
#define REGISTERSELECT    PA4

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
#define FUNCTION_SET            0x20

#define FUNCTION_SET_4BIT       0x00
#define FUNCTION_SET_8BIT       0x10
#define FUNCTION_SET_1LINE      0x00
#define FUNCTION_SET_2LINE      0x08
#define FUNCTION_SET_5X8        0x00
#define FUNCTION_SET_5X11       0x04

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
#define ENTRYMODE_SET            0x04

#define ENTRYMODE_SET_INCREMENT  0x02
#define ENTRYMODE_SET_DECREMENT  0x00
#define ENTRYMODE_SET_SHIFT      0x01
#define ENTRYMODE_SET_NO_SHIFT   0x00

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
#define LCD_CONTROL          0x08  // raw command (all off)

#define LCD_CONTROL_DISPLAY  0x04  // lcd on
#define LCD_CONTROL_CURSOR   0x02  // cursor on
#define LCD_CONTROL_BLINK    0x01  // blink on

/** lcd_control_memory: ---
 * The control memory is used for the Display ON/OFF Control,
 * because this command has to set both the LCD and the cursor
 * on or off. But for this driver we want seperate functions
 * for each LCD and cursor on/off.
 */
static uint8_t lcd_control_memory = 0x00;

/**
 * 'bit-0' is used to store the LCD status (1 = on; 0 = off)
 * 'bit-1' is used to store the cursor status (1 = on; 0 = off)
 * 'bit-2' is used to store the blink status (1 = on; 0 = off)
 */
#define LCD_CONTROL_MEMORY_DISPLAY_POSITION  0x00
#define LCD_CONTROL_MEMORY_CURSOR_POSITION   0x01
#define LCD_CONTROL_MEMORY_BLINK_POSITION    0x02

//------------------------------------------------------------
// CLEAR THE LCD:
//------------------------------------------------------------
//  RS | R/W | DB7 | DB6 | DB5 | DB4 | DB3 | DB2 | DB1 | DB0 |
//------------------------------------------------------------
//  0  |  0  |  0  |  0  |  0  |  0  |  0  |  0  |  0  |  1  |
//------------------------------------------------------------
// writes 0x20 ' ' (space) to all DDRAM addresses and return
// cursor home (address: 0x00)
#define CLEAR_LCD 0x01

//------------------------------------------------------------
// SET DDRAM ADDRESS:
//------------------------------------------------------------
//  RS | R/W | DB7 | DB6 | DB5 | DB4 | DB3 | DB2 | DB1 | DB0 |
//------------------------------------------------------------
//  0  |  0  |  1  | AC6 | AC5 | AC4 | AC3 | AC2 | AC1 | AC0 |
//------------------------------------------------------------
// set display data ram address (raw command)
#define SET_DDRAM 0x80

#define LCD_RAMADDRESS_LINE1 0x00
#define LCD_RAMADDRESS_LINE2 0x40

/**
 * Sends commmands to the LCD
 * when using this functino, it does not matter wheter
 * the lcd is in 4 or 8 bit mode.
 * - Use this function in the code
 * @param command
 *  The command to be executed by the lcd
 */
void lcd_write(uint8_t commmand);

/**
 * Writes data to the LCD
 * when using this functino, it does not matter wheter
 * the lcd is in 4 or 8 bit mode.
 * - Use this function in the code
 * @param data
 *  The data to write on the LCD
 */
void lcd_write_data(uint8_t data);

/**
 * Writes directly to the LCD in 4 bit mode.
 * For one full 8 bit LCD command, this function
 * has to be called twice.
 * @param command
 *  4 bits of the command to send to the LCD
 */
static void lcd_write4bit(uint8_t command);

/**
 * Writes data (characters) to the LCD in 4 bit mode.
 * For one full write cycle, this function
 * has to be called twice.
 * @param data
 *  4 bits of the data to send to the LCD
 */
static void lcd_write4bit_data(uint8_t data);

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
 * Clears all content on the LCD
 * by writeing ' ' (spaces) to all
 * LCD characters.
 */
void lcd_clear();

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
void lcd_set_position(uint8_t x, uint8_t y);

/**
 * Puts a number in hexadecimal format to the LCD
 * @param value
 *  The 8-bit value to put on the LCD
 */
void lcd_hex(uint8_t value);

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

/**
 * Puts a 16 bit (signed) integer to the LCD
 * @param number
 *  The number to put on the screen
 */
void lcd_int16(int16_t number);

#endif // LCD_H_
