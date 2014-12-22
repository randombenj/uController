#include <avr/io.h>
#include "../menu.h"
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

void home_up() {}
void home_down() {}
void home_left() {}
void home_right() {}
void home_enter() {}
