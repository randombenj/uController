#include <avr/io.h>
#include "timer.h"
#include <avr/interrupt.h>

time_t now = {
  .second = 0,
  .minute = 0,
  .hour = 0,
  .day = 0,
  .month = 0,
  .year = 0
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

ISR (TIMER2_COMPA_vect)
{
  TCCR2B = TCCR2B;
  now.second++;
  time_tick();

  while(ASSR & ((1<<TCN2UB) | (1<<OCR2AUB) | (1<<OCR2BUB) |
    (1<<TCR2AUB) | (1<<TCR2BUB)));
}

void time_tick()
{
  if(now.second == 60)
  {
    now.minute++;
    now.second = 0;
  }
  if(now.minute == 60)
  {
    now.hour++;
    now.minute = 0;
  }
  if(now.hour == 24)
  {
    now.hour = 0;
    now.day++;
  }

  if(now.day >= 28)
  {
    if(now.month == 2)
    {
      if(now.year % 4)
      {
        // leep jear
        if(now.day == 29)
        {
          now.day = 0;
          now.month++;
        }
      }
      else
      {
        if(now.day == 28)
        {
          now.day = 0;
          now.month++;
        }
      }
    }
    else
    {
      if(now.month < 7)
      {
        if(now.month % 2)
        {
          if(now.day == 30)
          {
            now.day = 0;
            now.month++;
          }
        }
        else
        {
          if(now.day == 31)
          {
            now.day = 0;
            now.month++;
          }
        }
      }
      else
      {
        if(now.month % 2)
        {
          if(now.day == 31)
          {
            now.day = 0;
            now.month++;
          }
        }
        else
        {
          if(now.day == 30)
          {
            now.day = 0;
            now.month++;
          }
        }
      }
    }
  }

  if(now.month == 12)
  {
    now.month = 0;
    now.year++;
  }
}
