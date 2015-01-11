#ifndef MENU_H_
#define MENU_H_

/**
 * Defines the Input switch
 */
#define SWICH            PINB
#define SWICH_D          DDRB

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
  char static_text[2][20 + 1];
} menu_t;

/**
 * Global menu
 */
extern menu_t menu[2];

/**
 * The current menu index
 */
extern uint8_t current_menu;

/**
 * Cursor X position on LCD
 */
extern uint8_t x_cursor_position;

/**
 * Cursor Y position on LCD
 */
extern uint8_t y_cursor_position;

/**
 * The current viewstate
 */
extern view_state_t view_state;

#include "menu/home.h"
#include "menu/timerselect.h"

/**
 * Handles menu actions
 * call this function in an endless loop
 */
void handle_menu();

/**
 * Gets the index of the
 * pressed input keys
 */
uint8_t get_input_index();

#endif // MENU_H_
