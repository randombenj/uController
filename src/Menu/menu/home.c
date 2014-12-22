#include <avr/io.h>
#include "../menu.h"
#include "../timer.h"
#include "../../Display/c/lcd.h"

/**
* HOME MENU:
*/
void home_init()
{
  lcd_set_position(0, 0);
  lcd_string(menu[0].static_text[0]);
  lcd_set_position(0, 1);
  lcd_string(menu[0].static_text[1]);
}

void home_update_time()
{
  lcd_set_position(0, 0);
  lcd_string(weekday_shorts[get_weekday(now.date)]);
  lcd_set_position(4, 0);
  lcd_int16(now.date.day);
  lcd_set_position(7, 0);
  lcd_int16(now.date.month);
  lcd_set_position(10, 0);
  lcd_int16(now.date.year);
  lcd_set_position(13, 0);
  lcd_int16(now.time.minute);
  lcd_set_position(16, 0);
  lcd_int16(now.time.second);
}

void home_up() {}
void home_down() {}
void home_left() {}
void home_right() {}
void home_enter() {}
