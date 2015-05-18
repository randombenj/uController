#include <avr/io.h>
#include "timer.h"
#include "dcf77.h"
#include <avr/interrupt.h>
#include "../../lib/c/bitmanipulation.h"
#include "../../lib/c/bool.h"

int lookup[8] = { 1, 2, 4, 8, 10, 20, 40, 80 };
bool_t is_clock_running = false;

void decode_signal(uint8_t second, uint8_t signal_info)
{
  now.time.second++;
  if (signal_info > 0)
  {
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
  DCF77_INPUT_D = 0x00; // all bits to input
  CLEAR_BIT(DCF77_INPUT_D, DCF77_INPUT_PORT); // input port to 'read'
  // Enable INT0 External Interrupt
  SET_BIT(EIMSK, INT0);
  // Falling and rising edge triggered
  SET_BIT(MCUCR, ISC00);
  // set prescaler of timer1 (16 bit) to 1024 1 second = 7812.5 clocks
  SET_BIT(TCCR1B, CS10);
  SET_BIT(TCCR1B, CS12);
  TCNT1 = 0x0000;
}

ISR(INT0_vect)
{
  if (IS_BIT_SET(DCF77_INPUT, DCF77_INPUT_PORT))
  {
    // signal high
    if (TCNT1 >= (TICKS_1_SECOND * 1.1)) // more than 1.1 second has passed
    {
      // new minute begins
      now.time.second = 0;
      is_clock_running = true;
    }
    else
    {
      now.time.second++;
    }
    //TCNT1 = 0x0000;
  }
  else
  {
    // signal low
    if (is_clock_running)
    {
      if (TCNT1 > (TICKS_1_SECOND * 0.19) && TCNT1 < (TICKS_1_SECOND * 0.24))
      {
        // between 190 ms & 240 ms (signalinfo = 1)
        decode_signal(now.time.second, 1);
      }
      else if (TCNT1 > (TICKS_1_SECOND * 0.08) && TCNT1 < (TICKS_1_SECOND * 0.15))
      {
        // between 80 ms and 150 ms (signalinfo = 0)
        decode_signal(now.time.second, 0);
      }
      else
      {
        // decoding has failed -> start from beginning
        is_clock_running = false;
      }
    }
  }
}
