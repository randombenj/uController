#include "../../../lib/c/atmega2560.h"
#include <avr/io.h>
#include <util/delay.h>
#include "lcd.h"
#include "../../../lib/c/bitmanipulation.h"
#include "../../../lib/c/type.h"

void lcd_write(uint8_t command)
{
  lcd_write4bit((SWAP_NIBBLES(command) & 0x0F)); // High nibble
  lcd_write4bit((command & 0x0F));               // Low nibble
}

void lcd_write_data(uint8_t data)
{
  lcd_write4bit_data((SWAP_NIBBLES(data) & 0x0F)); // High nibble
  lcd_write4bit_data((data & 0x0F));               // Low nibble
}

static void lcd_write4bit(uint8_t command)
{
  SET_BIT(LCD, ENABLE);
  _delay_us(20);
  LCD |= command;
  _delay_us(20);
  CLEAR_BIT(LCD, ENABLE);
  _delay_us(20);
  LCD = 0x00;
}

static void lcd_write4bit_data(uint8_t data)
{
  SET_BIT(LCD, REGISTERSELECT);
  _delay_us(1);
  lcd_write4bit(data);
  _delay_us(100);
}

void lcd_init()
{
  // Set data direction (write)
  LCD_D = 0xFF;
  // Be shure to turn on 8-bit mode. (Soft resets the LCD)
  _delay_ms(100);
  lcd_write4bit(0x03);
  _delay_ms(10);
  lcd_write4bit(0x03);
  _delay_ms(1);
  lcd_write4bit(0x03);
  _delay_ms(10);

  // Set lcd in 4 bit mode (high nibble only)
  lcd_write4bit(
    SWAP_NIBBLES(
      (
        FUNCTION_SET |
        FUNCTION_SET_4BIT
      )
    )
  );
  _delay_us(100);

  lcd_write(
    FUNCTION_SET |
    FUNCTION_SET_4BIT |
    FUNCTION_SET_2LINE |
    FUNCTION_SET_5X8
  );
  _delay_us(100);

  lcd_on();
  lcd_clear();

  lcd_write(
    ENTRYMODE_SET |
    ENTRYMODE_SET_INCREMENT |
    ENTRYMODE_SET_NO_SHIFT
  );
  _delay_ms(1);
}

void lcd_on()
{
  lcd_write(LCD_CONTROL | LCD_CONTROL_DISPLAY |
  ( // Turn cursor on if it has to be turned on
    (IS_BIT_SET(lcd_control_memory, LCD_CONTROL_MEMORY_CURSOR_POSITION)) ?
    LCD_CONTROL_CURSOR :
    0x00
  ));
  _delay_us(100);

  // Remember that the Display is now turned on
  SET_BIT(lcd_control_memory, LCD_CONTROL_MEMORY_DISPLAY_POSITION);
}

void lcd_off()
{
  lcd_write(LCD_CONTROL |
  ( // Turn cursor on if it has to be turned on
    (IS_BIT_SET(lcd_control_memory, LCD_CONTROL_MEMORY_CURSOR_POSITION)) ?
    LCD_CONTROL_CURSOR :
    0x00
  ));
  _delay_us(100);

  // Remember that the Display is now turned on
  CLEAR_BIT(lcd_control_memory, LCD_CONTROL_MEMORY_DISPLAY_POSITION);
}

void lcd_cursor_on()
{
  lcd_write(LCD_CONTROL | LCD_CONTROL_CURSOR |
    ( // Turn Display on if it has to be turned on
      (IS_BIT_SET(lcd_control_memory, LCD_CONTROL_MEMORY_DISPLAY_POSITION)) ?
      LCD_CONTROL_DISPLAY :
      0x00
    )
  );
  _delay_us(100);

  // Remember that the cursor is now turned on
  SET_BIT(lcd_control_memory, LCD_CONTROL_MEMORY_CURSOR_POSITION);
}

void lcd_cursor_off()
{
  lcd_write(LCD_CONTROL |
    ( // Turn Display on if it has to be turned on
      (IS_BIT_SET(lcd_control_memory, LCD_CONTROL_MEMORY_DISPLAY_POSITION)) ?
      LCD_CONTROL_DISPLAY :
      0x00
    )
  );
  _delay_us(100);

  // Remember that the cursor is now turned on
  CLEAR_BIT(lcd_control_memory, LCD_CONTROL_MEMORY_CURSOR_POSITION);
}

void lcd_clear()
{
  lcd_write(CLEAR_LCD);
  _delay_ms(10);
}

void lcd_string(char string[])
{
  while (*string != '\0')
  {
    lcd_char(*string++);
  }
}

void lcd_char(char character)
{
  lcd_write_data(character);
}

void lcd_hex(uint8_t value)
{
  // Hexadecimal prefix '0x__'
  lcd_char('0');
  lcd_char('x');
  // High nibble
  lcd_char(
    (
      ((SWAP_NIBBLES(value) & 0x0F) > 10) ?
      // Value 10 - 15 (A...F) to ascii
      ((SWAP_NIBBLES(value) & 0x0F) + 0x37) :
      // Value 0 - 9 (0...9) to ascii
      ((SWAP_NIBBLES(value) & 0x0F) + 0x30)
    )
  );
  // Low nibble
  lcd_char(
    (
      ((value & 0x0F) > 10) ?
      // Value 10 - 15 (A...F) to ascii
      ((value & 0x0F) + 0x37) :
      // Value 0 - 9 (0...9) to ascii
      ((value & 0x0F) + 0x30)
    )
  );
}

void lcd_set_position(uint8_t x, uint8_t y)
{
  uint8_t command = SET_DDRAM;
  switch (y)
  {
    case 0:
      command += (LCD_RAMADDRESS_LINE1 + x);
      break;
    case 1:
      command += (LCD_RAMADDRESS_LINE2 + x);
      break;
    default:
      return;
  }
  lcd_write(command);
}

void lcd_int16(int16_t number)
{
  bool is_leadin_zero = true;
  char string[4] = {
    '0', '0', '0', '0'
  };

  if (number < 0)
  {
    lcd_char('-');
    number = (~(number) + 1); // Two's complement
  }

  while(number >= 10000)
  {
    number -= 10000;
    string[0]++;
  }
  while(number >=  1000)
  {
    number -=  1000;
    string[1]++;
  }
  while(number >=   100)
  {
    number -=   100;
    string[2]++;
  }
  while(number >=   10)
  {
    number -=   10;
    string[3]++;
  }

  int i = 0;
  for(i = 0; i < 4; i++)
  {
    if (!is_leadin_zero || string[i] != '0')
    {
      is_leadin_zero = false;
      lcd_char(string[i]);
    }
  }

  lcd_char(((char)number + '0'));
}

void lcd_two_number(int8_t number)
{
  char string = '0';
  if (number < 100)
  {
    while(number >=   10)
    {
      number -=   10;
      string++;
    }

    lcd_char(string);
    lcd_char(((char)number + '0'));
  }
}
