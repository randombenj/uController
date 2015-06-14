#include <avr/io.h>
#include "timer.h"
#include "menu.h"
#include "menu/home.h"
#include "menu/timerselect.h"
#include "dcf77.h"
#include "../Display/c/lcd.h"
#include "../../lib/c/bitmanipulation.h"

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
  //SWICH_D = 0x00; // read from swich
  lcd_init();
  lcd_cursor_on();
  lcd_set_position(0,0);
  init_dcf77_interupt();
  home_init();
  /*timer_init();*/

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
  if (current_menu == 0 && time_has_changed)
  {
    home_redraw_time();
    time_has_changed = false;
  }
}

static uint8_t debounce_counter = 0;
static uint8_t input_flag = 0x00;

uint8_t get_input_index()
{
  uint8_t i = 0;
  uint8_t input = ~SWICH;
  for(i = 0; i < 8; i++)
  {
    if (input % 2)
    {
      if (debounce_counter >= 5 && IS_BIT_SET(input_flag, i))
      {
        return i;
      }
      else
      {
        if (input_flag && !IS_BIT_SET(input_flag, i))
        {
          input_flag = 0x00;
        }
        if (IS_BIT_SET(input_flag, i))
        {
          debounce_counter++;
        }
        else
        {
          SET_BIT(input_flag, i);
        }
        return 0xFF;
      }
    }
    input /= 2;
  }
  return 0xFF;
}
