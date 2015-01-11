#ifndef HOME_MENU_H_
#define HOME_MENU_H_

// HOME MENU:
/**
 * OnClick handler for 'up' key
 */
void home_up();

/**
 * OnClick handler for 'down' key
 */
void home_down();

/**
 * OnClick handler for 'left' key
 */
void home_left();

/**
 * OnClick handler for 'right' key
 */
void home_right();

/**
 * OnClick handler for 'enter' key
 */
void home_enter();

/**
 * Initialises the home menu (static text)
 */
void home_init();

/**
 * Redraws the time
 */
void home_redraw_time();

/**
 * Redraws the active timer
 */
void home_redraw_avtive();

/**
 * Edits the selected timer
 * @param step_size
 *  Add / Subtract size
 */
void edit_home(int8_t step_size);

/**
 * Add / Subtract years from the curent datetime
 * @param i
 *  Number of years
 */
void change_year(int8_t i);

/**
 * Add / Subtract monts from the curent datetime
 * @param i
 *  Number of months
 */
void change_month(int8_t i);

/**
 * Add / Subtract days from the curent datetime
 * @param i
 *  Number of days
 */
void change_day(int8_t i);

/**
 * Add / Subtract hours from the curent datetime
 * @param i
 *  Number of hours
 */
void change_hour(int8_t i);

/**
 * Add / Subtract minutes from the curent datetime
 * @param i
 *  Number of minutes
 */
void change_minute(int8_t i);

/**
 * Activates / Deactivates a timer at a
 * given index.
 * @param timer_index
 *  The index of the timer to toggle
 */
void toggle_active(int8_t timer_index);


#endif // HOME_MENU_H_
