#include <avr/io.h>
#include "../menu.h"
#include "../timer.h"
#include "home.h"
#include "../../Display/c/lcd.h"
#include "../../../lib/c/bitmanipulation.h"
#include <avr/delay.h>

uint8_t selected_timer_index = 0;

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
  y_cursor_position = 0;
  x_cursor_position = 6;
}

void timerselect_up()
{
  if (view_state == VIEW)
  {
    timerselect_timer_up();
  }
  if (view_state == EDIT)
  {
    edit_timerselect(1);
  }
}

void timerselect_down()
{
  if (view_state == VIEW)
  {
    timerselect_timer_down();
  }
  if (view_state == EDIT)
  {
    edit_timerselect(-1);
  }
}

void edit_timerselect(int8_t step_size)
{
  if (y_cursor_position == 0)
  {
    // start time
    if (x_cursor_position == 6)
    {
      change_time_hour(&timer[selected_timer_index].start_time, step_size);
    }
    if (x_cursor_position == 9)
    {
      change_time_minute(&timer[selected_timer_index].start_time, step_size);
    }
    // end time
    if (x_cursor_position == 11)
    {
      change_time_hour(&timer[selected_timer_index].end_time, step_size);
    }
    if (x_cursor_position == 14)
    {
      change_time_minute(&timer[selected_timer_index].end_time, step_size);
    }
  }
  else
  {
    if (x_cursor_position >= 5 && x_cursor_position <= 12)
    {
      toggle_portmask(x_cursor_position - 5);
      timerselect_redraw_portmask();
    }
    if (x_cursor_position >= 14 && x_cursor_position <= 20)
    {
      toggle_weekdaymask(x_cursor_position - 14);
      timerselect_redraw_weekdays();
    }
  }
}

void timerselect_left()
{
  if (view_state == VIEW)
  {
    // swich to home menu
    current_menu = 0;
    x_cursor_position = 0;
    y_cursor_position = 0;
    home_init();
  }
  if (view_state == EDIT)
  {
    if (y_cursor_position == 0)
    {
      if (x_cursor_position == 9 || x_cursor_position == 17)
      {
        x_cursor_position -= 3;
      }
      if (x_cursor_position == 14)
      {
        x_cursor_position -= 5;
      }
    }
    else
    {
      if (x_cursor_position == 4)
      {
        // edit portmask
        y_cursor_position = 0;
        x_cursor_position = 18;
      }
      if(x_cursor_position >= 13 && x_cursor_position <= 20)
      {
        x_cursor_position--;
      }
      if (x_cursor_position == 13)
      {
        x_cursor_position = 11;
      }
      if (x_cursor_position >= 4 && x_cursor_position <= 11)
      {
        x_cursor_position--;
      }
    }
  }
}

void timerselect_right()
{
  if (view_state == EDIT)
  {
    if (y_cursor_position == 0)
    {
      if (x_cursor_position == 6 || x_cursor_position == 14)
      {
        x_cursor_position += 3;
      }
      if (x_cursor_position == 9)
      {
        x_cursor_position += 5;
      }
      if (x_cursor_position == 17)
      {
        // edit portmask
        y_cursor_position = 1;
        x_cursor_position = 4;
      }
    }
    else
    {
      if (x_cursor_position >= 4 && x_cursor_position <= 11)
      {
        x_cursor_position++;
      }
      if (x_cursor_position == 11)
      {
        x_cursor_position = 13;
      }
      if(x_cursor_position >= 13 && x_cursor_position <= 20)
      {
        x_cursor_position++;
      }
    }
  }
}

void timerselect_enter()
{
  if (view_state == VIEW)
  {
    // toggle active of timer
    timer[selected_timer_index].active = !timer[selected_timer_index].active;
  }
  timerselect_redraw_timer();
}

void timerselect_timer_up()
{
  if (selected_timer_index > 0)
  {
    selected_timer_index--;
    _delay_ms(1000);
  }
  timerselect_redraw_timer();
}

void timerselect_timer_down()
{
  if (selected_timer_index < 7)
  {
    selected_timer_index++;
    _delay_ms(1000);
  }
  timerselect_redraw_timer();
}

void timerselect_redraw_timer()
{
  lcd_set_position(1, 0);
  lcd_int16(selected_timer_index + 1);
  lcd_set_position(6, 0);
  lcd_two_number(timer[selected_timer_index].start_time.hour);
  lcd_set_position(9, 0);
  lcd_two_number(timer[selected_timer_index].start_time.minute);
  lcd_set_position(14, 0);
  lcd_two_number(timer[selected_timer_index].end_time.hour);
  lcd_set_position(17, 0);
  lcd_two_number(timer[selected_timer_index].end_time.minute);

  lcd_set_position(1, 1);
  if (timer[selected_timer_index].active)
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
  uint8_t port_mask = timer[selected_timer_index].port_mask;
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
  uint8_t weekday_mask = timer[selected_timer_index].weekday_mask;
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

void change_time_minute(time_t *time, int8_t i)
{
  if (((*time).minute + i) >= 0 && ((*time).minute + i) < 60)
  {
    (*time).minute += i;
  }
}

void change_time_hour(time_t *time, int8_t i)
{
  if (((*time).hour + i) >= 0 && ((*time).hour + i) < 24)
  {
    (*time).hour += i;
  }
}

void toggle_portmask(int8_t mask_index)
{
  if (IS_BIT_SET(timer[selected_timer_index].port_mask, mask_index))
  {
    CLEAR_BIT(timer[selected_timer_index].port_mask, mask_index);
  }
  else
  {
    SET_BIT(timer[selected_timer_index].port_mask, mask_index);
  }
}

void toggle_weekdaymask(int8_t mask_index)
{
  if (IS_BIT_SET(timer[selected_timer_index].weekday_mask, mask_index))
  {
    CLEAR_BIT(timer[selected_timer_index].weekday_mask, mask_index);
  }
  else
  {
    SET_BIT(timer[selected_timer_index].weekday_mask, mask_index);
  }
}
