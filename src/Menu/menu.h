#ifndef MENU_H_
#define MENU_H_

/**
 * Function pointer returning void
 */
typedef void (*void_func_t)(void);

/**
 * Represents an enumeration of View States
 */
typedef enum {
 VIEW = 0,
 EDIT = 1
} view_state_t;

/**
 * Represents a menu type
 */
typedef struct {
  void_func_t actions[5];
  char static_text[40 + 1];
} menu_t;

/**
 * HOME MENU:
 */
void home_up();
void home_down();
void home_left();
void home_right();
void home_enter();

/**
 * TIMERSELECT MENU:
 */
void timerselect_up();
void timerselect_down();
void timerselect_left();
void timerselect_right();
void timerselect_enter();

#endif // MENU_H_
