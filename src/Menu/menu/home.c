#include <avr/io.h>
#include <avr/delay.h>
#include "../menu.h"
#include "../timer.h"
#include "home.h"
#include "../../Display/c/lcd.h"

/**
* HOME MENU:
*/
void home_init()
{
  uint8_t x_cursor_position = 5;
  uint8_t y_cursor_position = 0;
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
  lcd_two_number(now.time.hour);
  lcd_set_position(16, 0);
  lcd_two_number(now.time.minute);
  lcd_set_position(5, 1);
  lcd_two_number(get_weeknumber(now.date));
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

void home_up()
{
  if (view_state == EDIT)
  {
    uint8_t step_size = 1;
    if(y_cursor_position == 0)
    {
      if(x_cursor_position == 3)
      {
        change_day(step_size);
      }
      if(x_cursor_position == 6)
      {
        change_month(step_size);
      }
      if(x_cursor_position == 9)
      {
        change_year(step_size);
      }

      if(x_cursor_position == 12)
      {
        change_hour(step_size);
      }
      if(x_cursor_position == 15)
      {
        change_minute(step_size);
      }
    }
    else
    {
      toggle_active(x_cursor_position - 10);
      home_redraw_avtive();
    }
  }
}

void home_down()
{
  if (view_state == EDIT)
  {
    uint8_t step_size = -1;
    if(y_cursor_position == 0)
    {
      if(x_cursor_position == 3)
      {
        change_day(step_size);
      }
      if(x_cursor_position == 6)
      {
        change_month(step_size);
      }
      if(x_cursor_position == 9)
      {
        change_year(step_size);
      }

      if(x_cursor_position == 12)
      {
        change_hour(step_size);
      }
      if(x_cursor_position == 15)
      {
        change_minute(step_size);
      }
    }
    else
    {
      toggle_active(x_cursor_position - 10);
      home_redraw_avtive();
    }
  }

}

void home_left()
{
  if (view_state == EDIT)
  {
    if(y_cursor_position == 0)
    {
      if(x_cursor_position > 3)
      {
        x_cursor_position -= 3;
      }
    }
    else
    {
      if(x_cursor_position > 9)
      {
        x_cursor_position--;
      }
      else
      {
        // start editing time
        y_cursor_position = 0;
        x_cursor_position = 15;
      }
    }
  }
}

void home_right()
{
  if (view_state == VIEW)
  {
    // swich to timer menu
    current_menu = 1;
    x_cursor_position = 0;
    y_cursor_position = 0;
    timerselect_init();
  }
  if (view_state == EDIT)
  {
    if(y_cursor_position == 0)
    {
      if(x_cursor_position >= 15)
      {
        x_cursor_position += 3;
      }
      else
      {
        // start editing active timer
        y_cursor_position = 1;
        x_cursor_position = 9;
      }
    }
    else
    {
      if(x_cursor_position > 9)
      {
        x_cursor_position++;
      }
    }
  }
}

void home_enter()
{

}

void change_year(uint8_t i)
{
  now.date.year += i;
  _delay_ms(500);
}

void change_month(uint8_t i)
{
  now.date.month += i;
  _delay_ms(500);
}

void change_day(uint8_t i)
{
  now.date.day += i;
  _delay_ms(500);
}

void change_hour(uint8_t i)
{
  now.time.hour += i;
  _delay_ms(500);
}

void change_minute(uint8_t i)
{
  now.time.minute += i;
  _delay_ms(500);
}

void toggle_active(uint8_t timer_index)
{
  timer[timer_index].active = !timer[timer_index].active;
  _delay_ms(500);
}
