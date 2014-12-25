#ifndef TIMER_H_
#define TIMER_H_
#include "../../lib/c/type.h"

#define TIMER_PORT               PORTD
#define TIMER_PORT_D             DDRD

/**
 * Represents an enumeration of Weekdays
 */
typedef enum {
  MONDAY = 1,
  TUESDAY = 2,
  WEDNESDEY = 3,
  THURSDAY = 4,
  FRIDAY = 5,
  SATURDAY = 6,
  SUNDAY = 7
} weekday_t;

extern char weekday_shorts[7][3 + 1];

/**
 * Represents a time
 */
typedef struct {
  uint8_t second;
  uint8_t minute;
  uint8_t hour;
} time_t;

/**
 * Represents a date
 */
typedef struct {
  uint8_t day;
  uint8_t month;
  uint8_t year;
} date_t;

/**
* Represents a date time
*/
typedef struct {
  time_t time;
  date_t date;
} date_time_t;

extern date_time_t now;

/**
 * Represents a timer
 */
typedef struct {
  bool_t active;
  time_t start_time;
  time_t end_time;
  uint8_t weekday_mask;
  uint8_t port_mask;
} timer_t;

extern timer_t timer[8];

/**
 * Calculates the current week number
 */
uint8_t get_weeknumber(date_t time);

/**
 * Calculates the current weekday (0 = sunday)
 */
uint8_t get_weekday(date_t time);

/**
 * Initialise the timer
 */
void timer_init();

/**
 * One tick in a time
 */
void time_tick();

/**
 * Determines if a time is equal to another time
 * @param a
 *  Time a
 * @param b
 *  Time b
 * @return
 *  if time a is equal to time b
 */
bool time_equals(time_t a, time_t b);

#endif // TIMER_H_
