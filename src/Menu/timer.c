#include <avr/io.h>
#include "timer.h"
#include "../../lib/c/type.h"
#include <avr/interrupt.h>

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

timer_t timer[8] = {
  {
    .active = true,
    .start_time = {
      .second = 0,
      .minute = 0,
      .hour = 0,
    },
    .end_time = {
      .second = 0,
      .minute = 0,
      .hour = 0,
    },
    .weekday_mask = 0x00,
    .port_mask = 0x00
  },
  {
    .active = true,
    .start_time = {
      .second = 0,
      .minute = 0,
      .hour = 0,
    },
    .end_time = {
      .second = 0,
      .minute = 0,
      .hour = 0,
    },
    .weekday_mask = 0x00,
    .port_mask = 0x00
  },
  {
    .active = true,
    .start_time = {
      .second = 0,
      .minute = 0,
      .hour = 0,
    },
    .end_time = {
      .second = 0,
      .minute = 0,
      .hour = 0,
    },
    .weekday_mask = 0x00,
    .port_mask = 0x00
  },
  {
    .active = true,
    .start_time = {
      .second = 0,
      .minute = 0,
      .hour = 0,
    },
    .end_time = {
      .second = 0,
      .minute = 0,
      .hour = 0,
    },
    .weekday_mask = 0x00,
    .port_mask = 0x00
  },
  {
    .active = true,
    .start_time = {
      .second = 0,
      .minute = 0,
      .hour = 0,
    },
    .end_time = {
      .second = 0,
      .minute = 0,
      .hour = 0,
    },
    .weekday_mask = 0x00,
    .port_mask = 0x00
  },
  {
    .active = true,
    .start_time = {
      .second = 0,
      .minute = 0,
      .hour = 0,
    },
    .end_time = {
      .second = 0,
      .minute = 0,
      .hour = 0,
    },
    .weekday_mask = 0x00,
    .port_mask = 0x00
  },
  {
    .active = true,
    .start_time = {
      .second = 0,
      .minute = 0,
      .hour = 0,
    },
    .end_time = {
      .second = 0,
      .minute = 0,
      .hour = 0,
    },
    .weekday_mask = 0x00,
    .port_mask = 0x00
  },
  {
    .active = true,
    .start_time = {
      .second = 0,
      .minute = 0,
      .hour = 0,
    },
    .end_time = {
      .second = 0,
      .minute = 0,
      .hour = 0,
    },
    .weekday_mask = 0x00,
    .port_mask = 0x00
  }
};

void timer_init()
{
  // configure timer 2
  GTCCR |= (1 << TSM) | (1 << PSRASY);  // stop timer, reset prescaler
  ASSR |= (1 << AS2);                   // enable async mode
  TCCR2A = (1 << WGM21);                // CTC Modus
  TCCR2B |= (1 << CS22) | (1 << CS21);  // prescaler 256
  OCR2A = (128 / 4) - 1;
  TIMSK2 |= (1<<OCIE2A);                // enable compare interrupt
  GTCCR &= ~(1 << TSM);                 // start timer
  sei();                                // enable global interupts
}

uint8_t get_weekday(date_t date)
{
  uint8_t adjustment = ((14 - date.month) / 12);
  uint8_t mm = date.month + 12 * adjustment - 2;
  uint8_t yy = date.year - adjustment;
  return (date.day + (13 * mm - 1) / 5 +
  yy + yy / 4 - yy / 100 + yy / 400) % 7;
}

ISR (TIMER2_COMPA_vect)
{
  TCCR2B = TCCR2B;
  now.time.second++;
  time_tick();

  while(ASSR & ((1<<TCN2UB) | (1<<OCR2AUB) | (1<<OCR2BUB) |
    (1<<TCR2AUB) | (1<<TCR2BUB)));
}

void time_tick()
{
  if(now.time.second == 60)
  {
    now.time.minute++;
    now.time.second = 0;
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

  if(now.date.day >= 28)
  {
    if(now.date.month == 2)
    {
      if(now.date.year % 4)
      {
        // leep jear
        if(now.date.day == 29)
        {
          now.date.day = 0;
          now.date.month++;
        }
      }
      else
      {
        if(now.date.day == 28)
        {
          now.date.day = 0;
          now.date.month++;
        }
      }
    }
    else
    {
      if(now.date.month < 7)
      {
        if(now.date.month % 2)
        {
          if(now.date.day == 30)
          {
            now.date.day = 0;
            now.date.month++;
          }
        }
        else
        {
          if(now.date.day == 31)
          {
            now.date.day = 0;
            now.date.month++;
          }
        }
      }
      else
      {
        if(now.date.month % 2)
        {
          if(now.date.day == 31)
          {
            now.date.day = 0;
            now.date.month++;
          }
        }
        else
        {
          if(now.date.day == 30)
          {
            now.date.day = 0;
            now.date.month++;
          }
        }
      }
    }
  }

  if(now.date.month == 12)
  {
    now.date.month = 0;
    now.date.year++;
  }
}
