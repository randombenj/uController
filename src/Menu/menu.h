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
  char static_text[2][20 + 1];
} menu_t;

extern menu_t menu[2];

#include "menu/home.h"
#include "menu/timerselect.h"

#endif // MENU_H_
