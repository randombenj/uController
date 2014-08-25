
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
