#ifndef TIMERSELECT_MENU_H_
#define TIMERSELECT_MENU_H_

#include "../timer.h"

extern uint8_t selected_menu_index;

/**
* TIMERSELECT MENU:
*/
void timerselect_up();
void timerselect_down();
void timerselect_left();
void timerselect_right();
void timerselect_enter();

/**
* Initialises the timerselect menu (static text)
*/
void timerselect_init();
void timerselect_timer_up();
void timerselect_timer_down();
void timerselect_redraw_timer();
void timerselect_redraw_portmask();
void timerselect_redraw_weekdays();
void change_time_minute(time_t *time, int8_t i);
void change_time_hour(time_t *time, int8_t i);
void toggle_portmask(int8_t mask_index);
void toggle_weekdaymask(int8_t weekday_mask);
void edit_timerselect(int8_t step_size);


#endif // TIMERSELECT_MENU_H_
