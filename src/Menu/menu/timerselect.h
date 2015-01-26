#ifndef TIMERSELECT_MENU_H_
#define TIMERSELECT_MENU_H_

#include "../timer.h"

#define DEFAULT_DELAY 2000

/**
 * The index of the selected timer
 */
extern uint8_t selected_timer_index;

// TIMERSELECT MENU:
/**
 * OnClick handler for 'up' key
 */
void timerselect_up();

/**
 * OnClick handler for 'down' key
 */
void timerselect_down();

/**
 * OnClick handler for 'left' key
 */
void timerselect_left();

/**
 * OnClick handler for 'right' key
 */
void timerselect_right();

/**
 * OnClick handler for 'enter' key
 */
void timerselect_enter();

/**
* Initialises the timerselect menu (static text)
*/
void timerselect_init();

/**
 * Show the next timer
 */
void timerselect_timer_up();

/**
 * Show the previous timer
 */
void timerselect_timer_down();

/**
 * Redraw the timer on the LCD
 */
void timerselect_redraw_timer();

/**
 * Redraws the portmask on the LCD
 */
void timerselect_redraw_portmask();

/**
 * Redraws the weekdays on the LCD
 */
void timerselect_redraw_weekdays();

/**
 * Add / Subtract minutes from a given time
 * @param *time
 *  The time to be changed
 * @param i
 *  Number of minutes
 */
void change_time_minute(time_t *time, int8_t i);

/**
 * Add / Subtract hours from a given time
 * @param *time
 *  The time to be changed
 * @param i
 *  Number of hours
 */
void change_time_hour(time_t *time, int8_t i);

/**
 * Toggles the Port mask
 * (activate / deactivate a pin on the port)
 * @param mask_index
 *  Pin index on the port
 */
void toggle_portmask(int8_t mask_index);

/**
 * Toggles the Weekday mask
 * (activate / deactivate the timer on a weekday)
 * @param mask_index
 *  Index of the weekday
 */
void toggle_weekdaymask(int8_t mask_index);

/**
 * Edits the selected timer
 * @param step_size
 *  Add / Subtract size
 */
void edit_timerselect(int8_t step_size);


#endif // TIMERSELECT_MENU_H_
