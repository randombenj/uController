#How to: assembly

This is a tutorial to learn the (AVR-)Assembly language. This tutorial focuses on how to build assembly 
instructions based on higher languages like c/c++ etc. 

> !The tutorial is entirely based on my experience and stuff I read about assembly on the interwebs.

Ideas for improvment are welcome. :smile:

##Content
* [Interduction](#interduction)
  * [What is assembly](#what-is-assembly)
    * [Advantages and Disatvantages](#advantages-and-disatvantages)
* [Where to start](#where-to-start)
  * [Requirements](#requirements)
  * [RESET code](#reset-code)

##Interduction

Why this tutorial?

I have some experience on high level language such as c#, c, sql ...
All those languages are translated (in one way ore the other) to code the computer understands,
its quiet interesstiong to understand how thigs work on the deepest level.

> And µControllers are awesome ;D

###What is assembly

> [Assembly language Wikipedia](http://en.wikipedia.org/wiki/Assembly_language)

Assembly is a programming language, a **low level** programming laugage.
**Generaly** one assembly instruction takes one CPU cycle. That means if you have a 8MHz CPU you can perform 
make at best 8000000 assembly instructions per second.

> So a Intel i7 4770k@3.5GHz can make up to 3500000000 instructions per second!

![OMG Cat ^^](http://img.wonkette.com/wp-content/uploads/2013/10/OMG-cat.jpg)

####Advantages and Disatvantages

Atvangates | Disatvantages
--- | ---
As sayd before: Assembly is very, very fast, **Its the fastest way to program any Electronic Device** | To write good and readable assembly code you have to document your vode very well. Its not as comfoteable to write like higher programming languages like c, c++, c#, java, javascript ... But the highest disatvantage might be that you have to learn **new assembly commands for every new CPU/MCU you want to program with Assembly.**

##Where to start

###Requirements

> Do I need a µController?

Actualy no, AVR-Studio has a buitl in simulator wich can simulate your favourite µController.
But its quiet fun to see the program you built running on a thing you can hold in one hand.

> Where to buy a µController if I want one?

The [STK600](http://www.atmel.com/tools/stk600.aspx) starter kit comes with a programmer, and a ATMega2560 (the µController).
Or you can buy a raspberry pi and use it to program assembly (or to do other things such as: installing linux ^^, 
host your own webpages on your own little server ...).

> What IDE do I need?

For windows I would recomend the free IDE [AVR Studio 6](http://www.atmel.ch/microsite/atmel_studio6/).

> How do I know all assembly instructions?

The most important thing to learn the Assembly language for your CPU/MCU is to have a instruction-table. 
You can find Instruction tables for your device on the Internet. 

* [ATMega2560](http://www.atmel.ch/Images/doc2549.pdf) on page 416
* [Raspberry PI (ARM v7)](http://infocenter.arm.com/help/topic/com.arm.doc.ddi0301h/DDI0301H_arm1176jzfs_r0p7_trm.pdf) on page 58

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
PORTB is defined. This is done with .equ wich you can relate to in c as: `#define`
```nasm
; defining port b
.equ	PORTB	= 0x05
```
```c
// defining port b
#define PORTB	= 0x05
```



