#include <avr/io.h>
#include "timer.h"
#include "dcf77.h"
#include <avr/interrupt.h>
#include "../../lib/c/bitmanipulation.h"
#include "../../lib/c/bool.h"
#include "../../src/Display/c/lcd.h"

int lookup[8] = { 1, 2, 4, 8, 10, 20, 40, 80 };
bool_t is_clock_running = false;
date_time_t sync_time = {
  .date = {
    .day = 0,
    .month = 0,
    .year = 0
  },
  .time = {
    .second = 0,
    .minute = 0,
    .hour = 0,
  }
};

void decode_signal(uint8_t second)
{
  if (IS_IN_MEZ_SEZ_RANGE(second))
  {
    // TODO: MEZ and SEZ
  }
  if (IS_IN_MINUTE_RANGE(second))
  {
    sync_time.time.minute += lookup[MINUTE_LOOKUP_INDEX(second)];
  }
  if (IS_IN_HOUR_RANGE(second))
  {
    sync_time.time.hour += lookup[HOUR_LOOKUP_INDEX(second)];
  }
  if (IS_IN_DAY_RANGE(second))
  {
    sync_time.date.day += lookup[DAY_LOOKUP_INDEX(second)];
  }
  if (IS_IN_MONTH_RANGE(second))
  {
    sync_time.date.month += lookup[MONTH_LOOKUP_INDEX(second)];
  }
  if (IS_IN_YEAR_RANGE(second))
  {
    sync_time.date.year += lookup[YEAR_LOOKUP_INDEX(second)];
  }
}

void init_dcf77_interupt()
{
  DCF77_INPUT_D = 0x00; // all bits to input
  // Enable INT0 External Interrupt
  SET_BIT(EIMSK, INT0);
  // Falling and rising edge triggered
  SET_BIT(EICRA, ISC00);
  // set prescaler of timer1 (16 bit) to 1024 1 second = 7812.5 clocks
  SET_BIT(TCCR1B, CS10);
  SET_BIT(TCCR1B, CS12);
  TCNT1 = 0x0000;
  sei();
}

ISR(INT0_vect)
{
  if (IS_BIT_SET(DCF77_INPUT, DCF77_INPUT_PORT))
  {
    // signal high
    if (TCNT1 >= (TICKS_1_SECOND * 1.4)) // more than 1.4 second has passed
    {
      // Synchronistation has finished
      now = sync_time;
      // new minute begins
      sync_time.time.second = 0;
      is_clock_running = true;
      reset_synctime();
    }
    else
    {
      sync_time.time.second++;
      now.time.second++;
      time_tick();
    }
    TCNT1 = 0x0000;
  }
  else
  {
    // signal low
    if (is_clock_running)
    {
      if (TCNT1 > (TICKS_1_SECOND * 0.18) && TCNT1 < (TICKS_1_SECOND * 0.5))
      {
        // between 180 ms & 500 ms
        decode_signal(sync_time.time.second);
      }
      else if (!(TCNT1 > (TICKS_1_SECOND * 0.00) && TCNT1 < (TICKS_1_SECOND * 0.13)))
      {
        // decoding has failed -> start from beginning
        is_clock_running = false;
        // reset time
        reset_synctime();
      }
    }
  }
}

void reset_synctime()
{
  sync_time.date.day = 0;
  sync_time.date.month = 0;
  sync_time.date.year = 0;
  sync_time.time.hour = 0;
  sync_time.time.minute = 0;
  sync_time.time.second = 0;
}
