#ifndef TIMER_H_
#define TIMER_H_

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

/**
 * Represents a date time
 */
typedef struct {
  uint8_t second;
  uint8_t minute;
  uint8_t hour;
  uint8_t day;
  uint8_t month;
  uint8_t year;
} time_t;

extern time_t now;

/**
 * Represents a timer
 */
typedef struct {
  time_t start_time;
  time_t end_time;
  uint8_t weekday_mask;
  uint8_t port_mask;
} timer_t;

/**
 * Gets the current week number
 */
uint8_t get_www(time_t time);

/**
 * Initialise the timer
 */
void timer_init();

/**
 * One tick in a time
 */
void time_tick();

#endif // TIMER_H_
