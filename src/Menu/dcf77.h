#ifndef DCF77_H_
#define DCF77_H_

#include "../../lib/c/bool.h"

/**
 * Makro which determines wether the signal is in the
 * MEZ/SEZ range
 */
#define IS_IN_MEZ_SEZ_RANGE(second) (second >= 15 && second <= 20)
#define MEZ_SEZ_LOOKUP_INDEX(second) (second - 15)

/**
 * Makro which determines wether the signal is in the
 * Minute range
 */
#define IS_IN_MINUTE_RANGE(second) (second >= 21 && second <= 28)
#define MINUTE_LOOKUP_INDEX(second) (second - 21)

/**
 * Makro which determines wether the signal is in the
 * hour range
 */
#define IS_IN_HOUR_RANGE(second) (second >= 29 && second <= 35)
#define HOUR_LOOKUP_INDEX(second) (second - 29)

/**
 * Makro which determines wether the signal is in the
 * day range
 */
#define IS_IN_DAY_RANGE(second) (second >= 36 && second <= 41)
#define DAY_LOOKUP_INDEX(second) (second - 36)

/**
 * Makro which determines wether the signal is in the
 * weekday range
 */
#define IS_IN_WEEKDAY_RANGE(second) (second >= 42 && second <= 44)
#define WEEKDAY_LOOKUP_INDEX(second) (second - 42)

/**
 * Makro which determines wether the signal is in the
 * month range
 */
#define IS_IN_MONTH_RANGE(second) (second >= 45 && second <= 49)
#define MONTH_LOOKUP_INDEX(second) (second - 45)

/**
 * Makro which determines wether the signal is in the
 * year range
 */
#define IS_IN_YEAR_RANGE(second) (second >= 50 && second <= 57)
#define YEAR_LOOKUP_INDEX(second) (second - 50)

/*
* Has to be PORTD! Reference: ATmega2560 datasheet.
* INT0 -> PD0 (PORTD 0)
* If we use the switches, the interrupt is on SW0.
*/
#define DCF77_INPUT PIND
#define DCF77_PORT PORTD
#define DCF77_INPUT_D DDRD
#define DCF77_INPUT_PORT PD0

// Ticks of 16 bit tmier with prescaler at 1024
#define TICKS_1_SECOND 7812.5

extern int lookup[8];
// determines wether the clock synchronisatino is running or not
extern bool_t is_clock_running;
// time construct used for time synchronisation
extern date_time_t sync_time;

/**
 * Decodes the dcf77 signal and alters the current time
 * @param: second
 *  Second count (which second in a minute)
 * @param: signal_info
 *  The state of the signal 0 = low; 1 = high
 */
void decode_signal(uint8_t second, uint8_t signal_info);

/**
 * Resets the synchronisation time
 */
void reset_synctime();

#endif // DCF77_H_
