#include <avr/io.h>
#include "timer.h"
#include "menu.h"
#include "../Display/c/lcd.h"

menu_t menu[2] = {
  {
    .actions = {
      home_up,
      home_down,
      home_left,
      home_right,
      home_enter,
    },
    .static_text = {
      "      .  .     :    ",
      "    W   [        ]  "
    }
  },
  {
    .actions = {
      timerselect_up,
      timerselect_down,
      timerselect_left,
      timerselect_right,
      timerselect_enter,
    },
    .static_text = {
      "[ / ]   :   -   :   ",
      "[ ]         |       "
    }
  }
};

uint8_t x_cursor_position = 0;
uint8_t y_cursor_position = 0;
view_state_t view_state = VIEW;

int main()
{
  lcd_init();
  home_init();
  timer_init();
  while (1) {
    lcd_set_position(0, 0);
    lcd_int16(now.second);
  }
  return 0;
}
