#ifndef HOME_MENU_H_
#define HOME_MENU_H_

/**
* HOME MENU:
*/
void home_up();
void home_down();
void home_left();
void home_right();
void home_enter();
/**
* Initialises the home menu (static text)
*/
void home_init();
void home_redraw_time();
void home_redraw_avtive();
void edit_home(int8_t step_size);
void change_year(int8_t i);
void change_month(int8_t i);
void change_day(int8_t i);
void change_hour(int8_t i);
void change_minute(int8_t i);
void toggle_active(int8_t timer_index);


#endif // HOME_MENU_H_
