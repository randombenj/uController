#include <avr/io.h>
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
    .static_text = "      .  .     :        W   [        ]  "
  },
  {
    .actions = {
      timerselect_up,
      timerselect_down,
      timerselect_left,
      timerselect_right,
      timerselect_enter,
    },
    .static_text = "[ / ]   :   -   :   [ ]         |       "
  }
};

uint8_t x_cursor_position = 0;
uint8_t y_cursor_position = 0;
view_state_t view_state = VIEW;

int main()
{
  lcd_init();
  return 0;
}

/**
* HOME MENU:
*/
void home_up() {}
void home_down() {}
void home_left() {}
void home_right() {}
void home_enter() {}

/**
* TIMERSELECT MENU:
*/
void timerselect_up() {}
void timerselect_down() {}
void timerselect_left() {}
void timerselect_right() {}
void timerselect_enter() {}
