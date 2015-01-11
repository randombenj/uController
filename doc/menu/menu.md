# LCD Timer Menu

The LCD Timer Menu contains 8 timers which activate pins on a port. A timer has a
start and an end time (HH:MM). If the start time matches the end time, the timer
has to be turned off manualy (by holding enter). Additionaly to the start and
end time of the timer, the weekdays on which it will be triggered can be set.

## Mockup

```
+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+--+
| [ | 1 | / | 8 | ] |   | 1 | 2 | : | 1 | 1 |   | - |   | 1 | 2 | : | 1 | 2 |  |
+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+--+
| [ | x | ] |   | 1 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | | | M | T | W | T | S | S |  |
+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+--+


+---+---+---+--+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
| M | o | n |  | 1 | 0 | . | 1 | 2 | . | 1 | 4 |   | 1 | 1 | : | 1 | 1 |   |   |
+---+---+---+--+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
|   |   |   |  | W | 5 | 0 |   | [ | x | _ | _ | x | _ | x | x | _ | ] |   |   |
+---+---+---+--+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+

```

## Dependencies

> The LCD Timer depends on the [LCD Library](https://github.com/randombenj/uController/blob/master/doc/lcd-driver/lcd-driver.md).

* [timer.c](https://github.com/randombenj/uController/blob/master/src/Menu/timer.c) implements a clock which works with the timer overflow interupt.

### AVR-libc Dependencies

 * AVR standard I/O [avr/io.h](https://github.com/vancegroup-mirrors/avr-libc/blob/master/avr-libc/include/avr/io.h)
 * Delay [avr/delay.h](https://github.com/vancegroup-mirrors/avr-libc/blob/master/avr-libc/include/avr/delay.h)
 * Interrupts [avr/interupt.h](https://github.com/vancegroup-mirrors/avr-libc/blob/master/avr-libc/include/avr/interrupt.h)

## Requirements

 * Working clock
 * 8 Timers
 * Set weekdays of timer
 * Set port output of timer
 * Edit timer
 * Edit time
 * Activate/Deactivate timer
