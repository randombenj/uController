#include <avr/io.h>
#include "timer.h"
#include "dcf77.h"
#include <avr/interrupt.h>

int lookup[8] = { 1, 2, 4, 8, 10, 20, 40, 80 };

void decode_signal(uint8_t second, uint8_t signal_info)
{
  now.time.second++;
  if (signal_info > 0) {
    if (IS_IN_MEZ_SEZ_RANGE(second))
    {
      // TODO: MEZ and SEZ
    }
    if (IS_IN_MINUTE_RANGE(second))
    {
      now.time.minute += lookup[MINUTE_LOOKUP_INDEX(second)];
    }
    if (IS_IN_HOUR_RANGE(second))
    {
      now.time.hour += lookup[HOUR_LOOKUP_INDEX(second)];
    }
    if (IS_IN_DAY_RANGE(second))
    {
      now.date.day += lookup[DAY_LOOKUP_INDEX(second)];
    }
    if (IS_IN_MONTH_RANGE(second))
    {
      now.date.month += lookup[MONTH_LOOKUP_INDEX(second)];
    }
    if (IS_IN_YEAR_RANGE(second))
    {
      now.date.year += lookup[YEAR_LOOKUP_INDEX(second)];
    }
  }
}

void init_dcf77_interupt()
{
  // Enable INT0 External Interrupt
  EIMSK |= 1<<INT0;

  // Falling-Edge Triggered INT0 - This will depend on if you
  // are using a pullup resistor or a pulldown resistor on your
  // button and port
  MCUCR |= 1<<ISC00;
}

ISR(INT0_vect)
{
  // sachen
}
