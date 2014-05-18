# LCD-driver

## contents

* [description and requirements](#description-and-requirements)
    * [requirements](#requirements)

## description and requirements

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

### requirements

We use the 'JM202B REV A' LCD, which is a 20x2 characters display with a 16 bit interface. 


> See [here](http://www.jm.pl/karty/JM202BSPEC.pdf) for the datasheet.

**Implemented functions**

* `LCD_INI()`     Initialises the LCD
* `LCD_ON()`      Turns the LCD on
* `LCD_OFF()`     Turns the LCD off
* `CUR_OFF()`     Turns the cursof off
* `LCD_CLR()`     Clears the content shown on the LCD
* `LCD_RAM()`     Sets the RAM addres (sets the cursor tho a specific position)
* `LCD_CHR()`     Writes a ASCII character to the current cursor position
* `LCD_STR()`     Writes a character array to the current cursor position (terminator = '\0')
* `LCD_HEX()`     Writes a HEX number to the current curser postition (with "0x" prefix)
* `INT_16()`      Writes a 16 bit integer to the current curser position
