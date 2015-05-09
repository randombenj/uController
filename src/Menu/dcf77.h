#ifndef DCF77_H_
#define DCF77_H_

#include "../../lib/c/bool.h"

#define IS_IN_MEZ_SEZ_RANGE(second) (second >= 15 && second <= 20)
#define MEZ_SEZ_LOOKUP_INDEX(second) (second - 15)

#define IS_IN_MINUTE_RANGE(second) (second >= 21 && second <= 28)
#define MINUTE_LOOKUP_INDEX(second) (second - 21)

#define IS_IN_HOUR_RANGE(second) (second >= 29 && second <= 35)
#define HOUR_LOOKUP_INDEX(second) (second - 29)

#define IS_IN_DAY_RANGE(second) (second >= 36 && second <= 41)
#define DAY_LOOKUP_INDEX(second) (second - 36)

#define IS_IN_WEEKDAY_RANGE(second) (second >= 42 && second <= 44)
#define WEEKDAY_LOOKUP_INDEX(second) (second - 42)

#define IS_IN_MONTH_RANGE(second) (second >= 45 && second <= 49)
#define MONTH_LOOKUP_INDEX(second) (second - 45)

#define IS_IN_YEAR_RANGE(second) (second >= 50 && second <= 57)
#define YEAR_LOOKUP_INDEX(second) (second - 50)

#define DCF77_INPUT PIND
#define DCF77_INPUT_D DDRD
#define DCF77_INPUT_PORT PD1

#define TICKS_1_SECOND 7812.5

extern bool_t is_clock_running;

/**
 * Decodes the dcf77 signal and alters the current time
 * @param: second
 *  Second count (which second in a minute)
 * @param: signal_info
 *  The state of the signal 0 = low; 1 = high
 */
void decode_signal(uint8_t second, uint8_t signal_info);

#endif // DCF77_H_
