#include <avr/io.h>
#include "../menu.h"
#include "../timer.h"
#include "home.h"
#include "../../Display/c/lcd.h"

uint8_t selected_menu_index = 0;

/**
* TIMERSELECT MENU:
*/
void timerselect_init()
{
  lcd_set_position(0, 0);
  lcd_string(menu[1].static_text[0]);
  lcd_set_position(0, 1);
  lcd_string(menu[1].static_text[1]);
  timerselect_redraw_timer();
}

void timerselect_up() {}
void timerselect_down() {}
void timerselect_left()
{
  // swich to home menu
  current_menu = 0;
  home_init();
}
void timerselect_right() {}
void timerselect_enter() {}

void timerselect_timer_up()
{
  if (selected_menu_index > 0)
  {
    selected_menu_index--;
  }
  timerselect_redraw_timer();
}

void timerselect_timer_down()
{
  if (selected_menu_index <= 8)
  {
    selected_menu_index++;
  }
  timerselect_redraw_timer();
}

void timerselect_redraw_timer()
{
  lcd_set_position(1, 0);
  lcd_int16(selected_menu_index + 1);
  lcd_set_position(6, 0);
  lcd_two_number(timer[selected_menu_index].start_time.hour);
  lcd_set_position(9, 0);
  lcd_two_number(timer[selected_menu_index].start_time.minute);
  lcd_set_position(14, 0);
  lcd_two_number(timer[selected_menu_index].end_time.hour);
  lcd_set_position(17, 0);
  lcd_two_number(timer[selected_menu_index].end_time.minute);

  lcd_set_position(1, 1);
  if (timer[selected_menu_index].active)
  {
    lcd_char('X');
  }
  else
  {
    lcd_char(' ');
  }

  timerselect_redraw_portmask();
  timerselect_redraw_weekdays();
}

void timerselect_redraw_portmask()
{
  lcd_set_position(4, 1);
  uint8_t port_mask = timer[selected_menu_index].port_mask;
  uint8_t i = 0;
  for(i = 0; i < 8; i++)
  {
    if (port_mask % 2)
    {
      lcd_char('1');
    }
    else
    {
      lcd_char('0');
    }
    port_mask = port_mask / 2;
  }
}

void timerselect_redraw_weekdays()
{
  lcd_set_position(13, 1);
  uint8_t weekday_mask = timer[selected_menu_index].weekday_mask;
  uint8_t i = 0;
  for(i = 0; i < 8; i++)
  {
    if (weekday_mask % 2)
    {
      lcd_char(weekday_shorts[i][0]);
    }
    else
    {
      lcd_char('_');
    }
    weekday_mask = weekday_mask / 2;
  }
}
