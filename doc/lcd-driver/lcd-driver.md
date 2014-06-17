# LCD-driver

## Contents

* [Description and requirements](#Description-and-requirements)
    * [Requirements](#Requirements)

## Description and requirements

The LCD driver "speaks" with the LCD interface and puts content on the LCD screen. For this purpose various 
functions are implemented in AVR-Assembly, like: `LCD_INI()`, `LCD_ON()`, `LCD_OFF()` ... 

One of the difficultys is that we only use pin C (8 bit) but the LCD has 8 data lines and 
additionaly we need to set the RS (register select) bit. That means we would need to connect 9 pins. 
To avoid using two pin sets we switch to 4 bit mode. In 4 bit mode
only D7-D4 are connected to the MCU. Now we have to send two nibbles (1. high-nibble, 2. low-nibble)
at a time to send one byte. Explenation how to initlaise 4 bit mode:
[here](http://www.taoli.ece.ufl.edu/teaching/4744/labs/lab7/LCD_V1.pdf).

> See [here](https://github.com/randombenj/uController/blob/master/doc/lcd-driver/lcd-connection.md) how to connect 
the ATMEGA2560 with the LCD.

### Requirements

We use the 'JM202B REV A' LCD, which is a 20x2 characters display with a 16 bit interface. 


> See [here](http://www.jm.pl/karty/JM202BSPEC.pdf) for the datasheet.

**Implemented functions**

* `LCD_WRITE()`           Write 8 bit instruction to the lcd (abstraction layer)
* `LCD_WRITE_DATA()`      Write 8 bit data to the lcd (abstraction layer)
* `LCD_WRITE4BIT()`       4 bit instruction interface
* `LCD_WRITE4BIT_DATA()`  4 bit data interface
* `LCD_INI()`             Initialises the LCD
* `LCD_ON()`              Turns the LCD on
* `LCD_OFF()`             Turns the LCD off
* `CUR_OFF()`             Turns the cursof off
* `LCD_CLR()`             Clears the content shown on the LCD
* `LCD_RAM()`             Sets the RAM addres (sets the cursor tho a specific position)
* `LCD_CHR()`             Writes a ASCII character to the current cursor position
* `LCD_STR()`             Writes a character array to the current cursor position (terminator = '\0')
* `LCD_HEX()`             Writes a HEX number to the current curser postition (with "0x" prefix)
* `LCD_INT16()`           Writes a 16 bit integer to the current curser position
* `TO_CHAR()`             Converts a 4 bit number into a ascii character (1..9, A..F)
