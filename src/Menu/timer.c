#include <avr/io.h>
#include "timer.h"
#include "../../lib/c/type.h"
#include <avr/interrupt.h>
#include "../../lib/c/bitmanipulation.h"

#define DEFAULT_TIMER {   \
  .active = false,        \
  .start_time = {         \
    .second = 0,          \
    .minute = 0,          \
    .hour = 0,            \
  },                      \
  .end_time = {           \
    .second = 0,          \
    .minute = 0,          \
    .hour = 0,            \
  },                      \
  .weekday_mask = 0x00,   \
  .port_mask = 0x00       \
}

date_time_t now = {
  .date = {
    .day = 24,
    .month = 12,
    .year = 14
  },
  .time = {
    .second = 0,
    .minute = 0,
    .hour = 12,
  }
};

char weekday_shorts[7][3 + 1] = {
  "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
};

bool_t time_has_changed = false;

timer_t timer[8] = {
  DEFAULT_TIMER,
  DEFAULT_TIMER,
  DEFAULT_TIMER,
  DEFAULT_TIMER,
  DEFAULT_TIMER,
  DEFAULT_TIMER,
  DEFAULT_TIMER,
  DEFAULT_TIMER,
};

void timer_init()
{
  // set timer port to output
  TIMER_PORT_D = 0xFF;

  TCCR1A = 0;     // set entire TCCR1A register to 0
  TCCR1B = 0;     // same for TCCR1B

  // set compare match register to desired timer count:
  OCR1A = 15624 / 2;
  // turn on CTC mode:
  TCCR1B |= (1 << WGM12);
  // Set CS10 and CS12 bits for 1024 prescaler:
  TCCR1B |= (1 << CS10);
  TCCR1B |= (1 << CS12);
  // enable timer compare interrupt:
  TIMSK1 |= (1 << OCIE1A);

  sei();                                // enable global interupts
}

bool time_equals(time_t a, time_t b)
{
  return a.second == b.second &&
    a.minute == b.minute &&
    a.hour == b.hour;
}

uint8_t get_weekday(date_t date)
{
  uint8_t adjustment = ((14 - date.month) / 12);
  uint8_t mm = date.month + 12 * adjustment - 2;
  uint8_t yy = date.year - adjustment;
  return (date.day + (13 * mm - 1) / 5 +
    yy + yy / 4 - yy / 100 + yy / 400) % 7;
}

uint8_t get_weeknumber(date_t date)
{
  uint16_t days = date.day;

  while (--date.month)
  {
    days += get_month_days(date);
  }

  date_t date_jan_1 = {
    .day = 1,
    .month = 1,
    .year = date.year
  };

  uint8_t weekday = get_weekday(date_jan_1);
  if(weekday == 0)
  {
    weekday = 6;
  }
  else
  {
    weekday--;
  }

  uint8_t weeknumber = (days + weekday) / 7;
  return weeknumber + 1;
}

ISR (TIMER1_COMPA_vect)
{
  update_timer();
  now.time.second++;
  time_tick();
}

void update_timer()
{
  uint8_t i = 0;
  for(i = 0; i < 8; i++)
  {
    if(IS_BIT_SET(timer[i].weekday_mask, get_weekday(now.date)) &&
      time_equals(now.time, timer[i].start_time))
    {
      // start alarm
      TIMER_PORT = timer[i].port_mask;
    }
    if(IS_BIT_SET(timer[i].weekday_mask, get_weekday(now.date)) &&
      time_equals(now.time, timer[i].start_time) &&
      !time_equals(timer[i].start_time, timer[i].end_time))
    {
      // stop alarm
      TIMER_PORT = 0x00;
    }
  }
}

void time_tick()
{
  time_has_changed = true;
  if(now.time.second == 60)
  {
    now.time.minute++;
    now.time.second = 0;
    update_timer(); // show if a timer has to be triggered
  }

  if(now.time.minute == 60)
  {
    now.time.hour++;
    now.time.minute = 0;
  }

  if(now.time.hour == 24)
  {
    now.time.hour = 0;
    now.date.day++;
  }

  if(now.date.day == get_month_days(now.date))
  {
    now.date.day = 1;
    now.date.month++;
  }

  if(now.date.month == 13)
  {
    now.date.month = 1;
    now.date.year++;
  }
}

uint8_t get_month_days(date_t date)
{
  if(date.month == 2)
  {
    if((date.year % 4) == 0)
    {
      // leep year
      return 29;
    }
    else
    {
      return 28;
    }
  }
  else
  {
    if(date.month < 7)
    {
      if((date.month % 2) == 0)
      {
        return 30;
      }
      else
      {
        return 31;
      }
    }
    else
    {
      if((date.month % 2) == 0)
      {
        return 31;
      }
      else
      {
        return 30;
      }
    }
  }
}
