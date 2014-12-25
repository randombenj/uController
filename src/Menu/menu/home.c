#include <avr/io.h>
#include "../menu.h"
#include "../timer.h"
#include "home.h"
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
  home_redraw_avtive();
}

void home_redraw_time()
{
  lcd_set_position(0, 0);
  lcd_string(weekday_shorts[get_weekday(now.date)]);
  lcd_set_position(4, 0);
  lcd_two_number(now.date.day);
  lcd_set_position(7, 0);
  lcd_two_number(now.date.month);
  lcd_set_position(10, 0);
  lcd_two_number(now.date.year);
  lcd_set_position(13, 0);
  lcd_two_number(now.time.minute);
  lcd_set_position(16, 0);
  lcd_two_number(now.time.second);
  lcd_set_position(5, 1);
  lcd_hex(SWICH);
  //lcd_two_number(get_weeknumber(now.date));
}

void home_redraw_avtive()
{
  lcd_set_position(9, 1);
  uint8_t i = 0;
  for(i = 0; i < 8; i++)
  {
    if (timer[i].active)
    {
      lcd_char('X');
    }
    else
    {
      lcd_char('_');
    }
  }
}

void home_up() {}
void home_down() {}
void home_left() {}
void home_right()
{
  // swich to timer menu
  current_menu = 1;
  timerselect_init();
}
void home_enter() {}
