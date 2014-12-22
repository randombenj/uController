#include <avr/io.h>
#include "../menu.h"
#include "../../Display/c/lcd.h"

/**
* TIMERSELECT MENU:
*/
void timerselect_init()
{
  lcd_set_position(0, 0);
  lcd_string(menu[1].static_text[0]);
  lcd_set_position(0, 1);
  lcd_string(menu[1].static_text[1]);
}

void timerselect_up() {}
void timerselect_down() {}
void timerselect_left() {}
void timerselect_right() {}
void timerselect_enter() {}
