#include <avr/io.h>
#include "timer.h"
#include "menu.h"
#include "menu/home.h"
#include "menu/timerselect.h"
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
      "[ /8]   :   -   :   ",
      "[ ]         |       "
    }
  }
};

uint8_t x_cursor_position = 0;
uint8_t y_cursor_position = 0;
uint8_t current_menu = 0;

int main()
{
  SWICH_D = 0x00; // read from swich

  lcd_init();
  home_init();
  timer_init();

  while (1)
  {
    handle_menu();
  }

  return 0;
}

void handle_menu()
{
  uint8_t input_index = get_input_index();
  if (input_index < 0xFF)
  {
    menu[current_menu].actions[input_index]();
  }
  if (current_menu == 0)
  {
    home_redraw_time();
  }
}

uint8_t get_input_index()
{
  uint8_t i = 0;
  uint8_t input = ~SWICH;
  for(i = 0; i < 8; i++)
  {
    if (input % 2)
    {
      return i;
    }
    input /= 2;
  }
  return 0xFF;
}
