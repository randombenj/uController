#How to: assembly

This is a tutorial to learn the (AVR-)Assembly language. This tutorial focuses on how to build assembly 
instructions based on higher languages like c/c++ etc. 
!The tutorial is entirely based on my assembly experience and stuff from the interwebs.
Ideas for improvment are welcome. :D

##Content
* [Interduction](#Interduction)
* [Where to start](#Where-to-start)
  * [Requirements](#Requirements)
  * [RESET code](#RESET-code)

##Interduction

Why this tutorial?

I have some experience on high level language such as c#, c, sql ...
All those languages are translated (in one way ore the other) to code the computer understands,
its quiet interesstiong to understand how thigs work on the deepest level.

> And µControllers are awesome ;D

##Where to start

###Requirements

> Do I need a µController?

Actualy no. AVR-Studio has a buitl in simulator wich can simulate your favourite µController.
But its quiet fun to see the program you built running on a thing you can hold in one hand.

> Where to buy a µController if I want one?

The [STK600](http://www.atmel.com/tools/stk600.aspx) starter kit comes with a programmer, and a ATMega2560 (the µController).
Or you can buy a raspberry pi and use it to program assembly (or to do other things such as: installing linux ^^, 
host your own webpages on your own little server ...).

> What IDE do I need?

For windows I would recomend the free IDE [AVR Studio 6](http://www.atmel.ch/microsite/atmel_studio6/).

###RESET code

For my projects I use the [header](https://github.com/randombenj/uController/blob/master/AVR_Header.asm) file wich we got from the µController-course.

> **!Documentation is verry important when writing assembly code.**

A code command in assembly beginss with ";"

```nasm
; some random command ...
```

####The [header](https://github.com/randombenj/uController/blob/master/AVR_Header.asm) file explained:

```nasm
.include "m2560def.inc"
```
In the "m2560def.inc" file are all I/O registers named. So to use Port B you can:
```nasm
in    r16,    PORTB             ;read PORTB
```
So you don't have to know the hex address for the "PORTB". If you search for: "PORTB" you will find the line where
PORTB is defined. This is done with .equ wich you can relate to in c as: #define
```nasm
; defining port b
.equ	PORTB	= 0x05
```
```c
// defining port b
#define PORTB	= 0x05
```



