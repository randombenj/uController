#ifndef TIMERSELECT_MENU_H_
#define TIMERSELECT_MENU_H_

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


#endif // TIMERSELECT_MENU_H_
