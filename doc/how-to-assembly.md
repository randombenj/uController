#How to: assembly

This is a tutorial to learn the AVR-Assembly language. It also covers what Microcontrollers are and why/where you should or shouldn't programm assembly.

> The tutorial is entirely based on my experience and stuff I read about assembly on the interwebs.

Ideas for improvment are welcome. :smile:

---

##Content
* [Interduction](#interduction)
  * [What is assembly](#what-is-assembly)
    * [Advantages and Disatvantages](#advantages-and-disatvantages)
* [Where to start](#where-to-start)
  * [The Controller](#the-controller)
    * [Hardware basics](#hardware-basics)
  * [Requirements](#requirements)
  * [RESET code](#reset-code)

##Interduction

Why this tutorial?

I have some experience on high level language such as c#, c, sql ...
All those languages are translated (in one way or the other) to code the computer understands,
its quiet interesting to understand how things work on the deepest level.

Additionaly microcontrollers have the scale that its possible to understande what's going on under the hood.
In the case of the ATMega2560 (8 bit MCU) this is about a 450 page size PDF. 

###What is assembly

> [Assembly language Wikipedia](http://en.wikipedia.org/wiki/Assembly_language)

Assembly is a programming language, a **low level** programming laugage.
**Generaly** one assembly instruction takes one CPU cycle (in RISC arcitecture). That means if you have a 8MHz RISC CPU it can make at best 8000000 assembly instructions per second (some instructions require more then one CPU clock to run). 

####Advantages and Disatvantages

There are so many good high-level programming languages, so where and why does it make sense to programm assembly? 
When you write an operating system the first little bit of code is most likly assembly 
(see the Linux Kernel for example). Also if you are programming microcontrollers and need very high performance, 
assembly is your choize. My personal motivation to learn assembly, is to learn how a basic computer-system works 
from the very basics.

Advantages | Disadvantages
--- | ---
As said before: Assembly is very, very fast, **Its the fastest way to program any electronic Device** | To write good and readable assembly code you have to document your code very well. Its not as comfortable as higher programming languages like c, c++, c#, java, javascript ... But the highest disadvantage might be that you have to learn **new assembly commands for every new CPU/MCU you want to program with Assembly.**. An other thing is that you have to rewrite your program for every CPU typ the program will run on.

##Where to start

###The Controller

> If i want to buy a µController which one should I choose?

 * The [STK600](http://www.atmel.com/tools/stk600.aspx) is a µController starter kit and comes with the ATMega2560 MCU.
 * [Arduino](http://arduino.cc/) also uses µControllers from Atmel for example the [Arduino Uno](http://arduino.cc/en/Main/ArduinoBoardUno) uses the ATmega328 microcontroller from Atmel. The Arduino boards also have a great community.
 * The Raspberry PI. Its not especially a microcontroller but you can in fact program any CPU with assembly. For "only" programming in assembly language the Raspberry is a bit overpowered.
 * If you want a real challenge you can write your own little "hello-world" operating system with assembly for your Desktop PC: [Tutorial: Hello-World OS](http://mikeos.berlios.de/write-your-own-os.html)

####Hardware basics

**RISC vs CISC**

RISC and CISC stand for [*Reduced instruction set computing*](http://en.wikipedia.org/wiki/Reduced_instruction_set_computing) and [*Complex instructing set computing*](http://en.wikipedia.org/wiki/Complex_instruction_set_computing). RISC and CISC are both CPU design strategies.

RISC | CISC
---|---
RISC CPUs are less complex then CISC CPUs. What does this mean? This menans that the CPU can execute one command in one clock (8 MHz = 8000000 clocks per second). But it also means that there are less instructions then on a CISC CPU. So you have to write more complex assembly code. RISC CPUs are used where you have to save power e.g. your smartphone, microcontroller, raspberry pi, arm CPU, ... | CISC CPUs have much more instructions than a RISC CPU, but one complex CISC instruction can take multiple clocks. Advantages are that you dont have to write as much assembly code for some operations as in a RISC cpu. Intel uses the CISC arcitecture but also with some RISC features.

###Requirements

- **Microcontroller**

You don't actualy need a Microcontroller in AVR studio you can use the simulator, but if you buy 
one, the possibilities what to do with it are only limited by your imagination.

To use the Microcontroller you also need a programmer to flash your programms to the MCU itselve.
Because of this I recomend buying the [STK600](http://www.atmel.com/tools/stk600.aspx) 
(which is actualy a programmer for vaious AVR MCUs and includes the ATMega2560 MCU) 
or the Arduino which has its own programmer included (the arduino's microcontroller is also from AVR).
If you have a Raspberry PI you can use it as well to learn assembly. The pi however has an ARM CPU
so instead of learning the AVR assembly language you have to learn the ARM assembly language.

- **Development Environement**

For Windows I would recommend the free IDE [AVR Studio 6](http://www.atmel.ch/microsite/atmel_studio6/).

- **Know the assembly**

The most important thing to learn the assembly language for your CPU/MCU is to have a instruction-table.
You can find Instruction tables for your device on the Internet. 

* [ATMega2560](http://www.atmel.ch/Images/doc2549.pdf) on page 416
* Arduino's [ATmega328](http://www.atmel.com/Images/doc8161.pdf) on page 427
* [Raspberry PI (ARM v7)](http://infocenter.arm.com/help/topic/com.arm.doc.ddi0301h/DDI0301H_arm1176jzfs_r0p7_trm.pdf) on page 58

###RESET code

For my projects I use the [header](https://github.com/randombenj/uController/blob/master/AVR_Header.asm) file which we got from the µController-course.

> **Documentation is very important when writing assembly code.**

A code comment in assembly beginss with `;`

```nasm
; some random comment ...
```

####The [header](https://github.com/randombenj/uController/blob/master/AVR_Header.asm) file explained:

> Why use the header file?

All my projects are based on the header file, this is because its a great entry point and all important initialisations are already done e.g. stack initialisation.

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
> Wich line is executed first?

Simple: the first one. Assembly is executed from top to bottom, now we have to find the first command. Line 1 - 23 are comments:

```nasm
;===============================================================================
;- Program:             
;-
;- Filename:            .asm
;- Version:             1.0.0
;- Autor:               Benj Fassbind
;-
;- Purpose:             uP-Schulung
;-
;- Description:
;-          

;- ... and so on ...

;--- uController ---
```
Then there is the `.include "m2560def.inc"` wich only contains `.equ` so that we don't have to know all the adresses by heart. 
```nasm
        RJMP   Reset            ; Ext-Pin, Power-on, Brown-out,Watchdog Reset
```
There we have it. `RJMP Reset`. What does it do? When the program is loaded on to the MCU and hits this line, the programm counter will be 1. The program counter will be explained later.

> `RJMP Reset` WAT?

If we look in to our instruction set table and search for the command `RJMP` we will notice that this is a jump command.
It jumps to the label Reset. Now we search for `Reset`:

```nasm
        ;--- Initialisation ---
Reset:    SER         mpr                       ; Output:= LED
          OUT         LED_D, mpr

          CLR         mpr                       ; Input:= Switch-values
          OUT         SWITCH_D, mpr

          LDI         mpr, LOW(RAMEND)          ; Initialise stack
          OUT         SPL,mpr
          LDI         mpr, HIGH(RAMEND)
          OUT         SPH,mpr
```

Labels are defined by giving them a name and a `:` like `Reset:`. Now we can Jump to the Reset label with the `RJMP` command.

To understand the Reset routine we first have to understand how i/o pins work. Important for this part is this code:

```nasm
;--- constants ---
.equ     LED          = PORTB         ; Output for LED
.equ     LED_D        = DDRB          ; Data direction Port for LED

.equ     SWITCH       = PIND          ; Input for SWITCH
.equ     SWITCH_D     = DDRD          ; Data direction Port for SWITCH

;--- variables ---
.def      mpr         = R16           ; multipurpose register
```

We already know the `.equ` command. With the first four `.equs` we are just renaming **PORTB** to our LED (Output) and **PIND** to our SWITCH (input). 

You have to use **PIN** for input and **PORT** for input.

On the next line we see a new command `.def`. Some assembly instructions need registers to save the in and output data of the performing instruction. 

e.g. if you add two numbers together you ned at least two numbers (stored in registers). One for the 1. summand and one for the 2. summand plus you can use one of the two registers as the result. In a higher level language you would write:

`a = a + b`

To use the Registers you simply can write `R1` to `R30`. With the `.def` command you can give the registers a name.

Now we can go back to the **Reset** code.
