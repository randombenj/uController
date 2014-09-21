# A collection of AVR C tricks

> Source code of the **[avr runtime library (avr-libc)](http://www.nongnu.org/avr-libc/)**
  and a *[git mirror](https://github.com/vancegroup-mirrors/avr-libc)* on github

# Content

 * [I/O](#io)
   * [Get IO port reference](#get-io-port-reference)


## I/O

### Get I/O port reference

Pass a I/O port reference to a function the correct way:

``` c
#include <avr/io.h>  // Device specific port I/O definition

void port_write(volatile uint8_t *port, uint8_t value)
{
    *port = value;
}

int main (void)
{
    port_write(&PORTB, 0xFF);
    return (0);
}

```

This code will access the port with assembly commands `LD` and `ST`,
not `IN` and `OUT`

**Explanation**

If we, for example take PORTB of the ATMega2560,
then you have to specify the `-mmcu=atmega2560` target device.
The compiler then internaly defines `__AVR_ATmega2560`.

``` c
#elif defined (__AVR_ATmega2560__)
#  include <avr/iom2560.h>
```

This file then includes the ATMega series I/O definition.
And there we find the definition of PORTB.

``` c
#define PORTB   _SFR_IO8(0x05)
```

The `_SFR_IO8()` macro is from `<avr/sfr_defs.h>` which is included in `<avr/io.h>`.

``` c
#define _SFR_IO8(io_addr) _MMIO_BYTE((io_addr) + __SFR_OFFSET)
```

The `_MMIO_BYTE()` comes from the same file.

``` c
#define _MMIO_BYTE(mem_addr) (*(volatile uint8_t *)(mem_addr))
```

Everything combined will preprocess from `PORTB` to this:

``` c
(*(volatile uint8_t *)((0x05) + 0x20))
```

*Note that if `__SFR_OFFSET` is not defined it's defaut value is 0x20.*

> Source: [www.atmel.com FAQ](http://www.atmel.com/webdoc/AVRLibcReferenceManual/FAQ_1faq_port_pass.html)
  and [an www.avrfreaks.net quetion](http://www.avrfreaks.net/forum/how-does-ddrb0xff-work?name=PNphpBB2&file=viewtopic&t=70109)
