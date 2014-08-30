#include "../../../lib/c/atmega2560.h"
#include <avr/io.h>
#include <util/delay.h>
#include "lcd.h"
#include "../../../lib/c/bitmanipulation.h"
#include "../../../lib/c/type.h"

#define LCD               PORTA
#define LCD_D             DDRA


int main(void)
{
  LCD_D = 0xFF;
  lcd_init();
  lcd_char('A');
  for(;;);
}

void lcd_write(byte command)
{
  lcd_write4bit((SWAP_NIBBLES(command) & 0x0F)); // High nibble
  lcd_write4bit((command & 0x0F));               // Low nibble
}

void lcd_write_data(byte data)
{
  lcd_write4bit_data((SWAP_NIBBLES(data) & 0x0F)); // High nibble
  lcd_write4bit_data((data & 0x0F));               // Low nibble
}

void lcd_write4bit(byte command)
{
  SET_BIT(LCD, ENABLE);
  _delay_us(20);
  LCD |= command;
  _delay_us(20);
  CLEAR_BIT(LCD, ENABLE);
  _delay_us(20);
  LCD = 0x00;
}

void lcd_write4bit_data(byte data)
{
  SET_BIT(LCD, REGISTERSELECT);
  _delay_us(1);
  lcd_write4bit(data);
  _delay_us(100);
}

void lcd_init()
{
  // Be shure to turn on 8-bit mode. (Soft resets the LCD)
  _delay_ms(100);
  lcd_write4bit(0x03);
  _delay_ms(10);
  lcd_write4bit(0x03);
  _delay_ms(1);
  lcd_write4bit(0x03);
  _delay_ms(10);

  lcd_write4bit(0x02);
  _delay_us(100);

  lcd_write(FUNCTION_SET);
  _delay_us(100);

  lcd_on();
  lcd_clear();

  lcd_write(ENTRYMODE_SET);
  _delay_ms(1);
}

void lcd_on()
{
  byte command = LCD_CTRL_LCD;
  // TODO: Cursor
  lcd_write(command);
  _delay_us(100);
}

void lcd_clear()
{
  lcd_write(CLEAR_LCD);
  _delay_ms(10);
}


void lcd_char(char character)
{
  lcd_write_data(character);
}
