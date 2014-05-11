;===============================================================================
;- Program:             display
;-
;- Filename:            display.asm
;- Version:             1.0.0
;- Autor:               Benj Fassbind
;-
;- Purpose:             uP-Schulung
;-
;- Description:
;-          
;-                    
;-
;- Entwicklungsablauf:
;- Version:  Datum:     Autor:   Entwicklungsschritt:               Zeit:
;- 1.0.0     01.01.13   FAB      Ganzes Programm erstellt               Min.
;-
;-                                                  Totalzeit:      Min.
;-
;- Copyright: Benj Fassbind, Sonneggstrasse 13, 6410 Goldau (2013)
;------------------------------------------------------------------------------

;--- uController ---
.include "m2560def.inc"

;--- INTERRUPT-ADDRESS-VECTORS ---
; -> Use 'nop' because interrupt-addresses are 16 bit,
;    even though its a 8 bit MCU
        RJMP   reset            ; Ext-Pin, Power-on, Brown-out,Watchdog Reset
        NOP                     ;  0x0000
        RETI                    ; External Interrupt Request 0
        NOP                     ;  0x0002
        RETI                    ; External Interrupt Request 1
        NOP                     ;  0x0004
        RETI                    ; External Interrupt Request 2
        NOP                     ;  0x0006
        RETI                    ; External Interrupt Request 3
        NOP                     ;  0x0008
        RETI                    ; External Interrupt Request 4
        NOP                     ;  0x000A
        RETI                    ; External Interrupt Request 5
        NOP                     ;  0x000C
        RETI                    ; External Interrupt Request 6
        NOP                     ;  0x000E
        RETI                    ; External Interrupt Request 7
        NOP                     ;  0x0010
        RETI                    ; Pin Change Interrupt Request 0
        NOP                     ;  0x0012
        RETI                    ; Pin Change Interrupt Request 1
        NOP                     ;  0x0014
        RETI                    ; Pin Change Interrupt Request 2
        NOP                     ;  0x0016
        RETI                    ; Watchdog Time-out Interrupt
        NOP                     ;  0x0018
        RETI                    ; Timer/Counter2 Compare Match A
        NOP                     ;  0x001A
        RETI                    ; Timer/Counter2 Compare Match B
        NOP                     ;  0x001C
        RETI                    ; Timer/Counter2 Overflow
        NOP                     ;  0x001E
        RETI                    ; Timer/Counter1 Capture Event
        NOP                     ;  0x0020
        RETI                    ; Timer/Counter1 Compare Match A
        NOP                     ;  0x0022
        RETI                    ; Timer/Counter1 Compare Match B
        NOP                     ;  0x0024
        RETI                    ; Timer/Counter1 Compare Match C
        NOP                     ;  0x0026
        RETI                    ; Timer/Counter1 Overflow
        NOP                     ;  0x0028
        RETI                    ; Timer/Counter0 Compare Match A
        NOP                     ;  0x002A
        RETI                    ; Timer/Counter0 Compare Match B
        NOP                     ;  0x002C
        RETI                    ; Timer/Counter0 Overflow
        NOP                     ;  0x002E
        RETI                    ; SPI Serial Transfer Complete
        NOP                     ;  0x0030
        RETI                    ; USART0 Rx Complete
        NOP                     ;  0x0032
        RETI                    ; USART0 Data Register Empty
        NOP                     ;  0x0034
        RETI                    ; USART0 Tx Complete
        NOP                     ;  0x0036
        RETI                    ; Analog Comparator
        NOP                     ;  0x0038
        RETI                    ; ADC Conversion Complete
        NOP                     ;  0x003A
        RETI                    ; EEPROM Ready
        NOP                     ;  0x003C
        RETI                    ; Timer/Counter3 Capture Event
        NOP                     ;  0x003E
        RETI                    ; Timer/Counter3 Compare Match A
        NOP                     ;  0x0040
        RETI                    ; Timer/Counter3 Compare Match B
        NOP                     ;  0x0042
        RETI                    ; Timer/Counter3 Compare Match C
        NOP                     ;  0x0044
        RETI                    ; Timer/Counter3 Overflow
        NOP                     ;  0x0046
        RETI                    ; USART1 Rx Complete
        NOP                     ;  0x0048
        RETI                    ; USART1 Data Register Empty
        NOP                     ;  0x004A
        RETI                    ; USART1 Tx Complete
        NOP                     ;  0x004C
        RETI                    ; 2-wire Serial Interface
        NOP                     ;  0x004E
        RETI                    ; Store Program Memory Ready
        NOP                     ;  0x0050
        RETI                    ; Store Program Memory Ready
        NOP                     ;  0x0052
        RETI                    ; Timer/Counter4 Capture Event
        NOP                     ;  0x0054
        RETI                    ; Timer/Counter4 Compare Match A
        NOP                     ;  0x0056
        RETI                    ; Timer/Counter4 Compare Match B
        NOP                     ;  0x0056
        RETI                    ; Timer/Counter4 Compare Match C
        NOP                     ;  0x0058
        RETI                    ; Timer/Counter4 Overflow
        NOP                     ;  0x005A
        RETI                    ; Timer/Counter5 Capture Event
        NOP                     ;  0x005C
        RETI                    ; Timer/Counter5 Compare Match A
        NOP                     ;  0x005E
        RETI                    ; Timer/Counter5 Compare Match B
        NOP                     ;  0x0060
        RETI                    ; Timer/Counter5 Compare Match C
        NOP                     ;  0x0062
        RETI                    ; Timer/Counter5 Overflow
        NOP                     ;  0x0064
        RETI                    ; USART2 Rx Complete
        NOP                     ;  0x0066
        RETI                    ; USART2 Data Register Empty
        NOP                     ;  0x0068
        RETI                    ; USART2 Tx Complete
        NOP                     ;  0x006A
        RETI                    ; USART3 Rx Complete
        NOP                     ;  0x006C
        RETI                    ; USART3 Data Register Empty
        NOP                     ;  0x006E
        RETI                    ; USART3 Tx Complete
        NOP                     ;  0x0070

;--- Include-Files ---




;--- constants ---
.equ     LED          = PORTB         ; Output for LED
.equ     LED_D        = DDRB          ; Data direction Port for LED

.equ     SWITCH       = PIND          ; Input for SWITCH
.equ     SWITCH_D     = DDRD          ; Data direction Port for SWITCH

;--- variables ---
.def      mpr         = R16           ; multipurpose register



;------------------------------------------------------------------------------
; Main program
;------------------------------------------------------------------------------

;--- Initialisation ---
Reset:    SER         mpr                       ; Output:= LED
          OUT         LED_D, mpr

          CLR         mpr                       ; Input:= Switch-values
          OUT         SWITCH_D, mpr

          LDI         mpr, LOW(RAMEND)          ; Initialise stack
          OUT         SPL,mpr
          LDI         mpr, HIGH(RAMEND)
          OUT         SPH,mpr


;--- Main program: ---     
Main:     										; main function
		  
		  
		  
		  RJMP		  Main						; endless loop

;------------------------------------------------------------------------------
; Subroutines
;------------------------------------------------------------------------------
;==============================================================================
; @name:	LCD_INI
; @description:
;  Initialises the Display. Sets up the communication from the Display to the
;  microcontroller.
;
;------------------------------------------------------------------------------
LCD_INI:										; display initialisation
		
		 

		 RET									; return from function



;==============================================================================
; @name:	LCD_ON
; @description:
;  Turns the LCD-Display on.
;
;------------------------------------------------------------------------------
LCD_ON:											; turn display on
		
		

		RET										; return from function

;==============================================================================
; @name:	LCD_OFF
; @description:
;  Turns the LCD-Display off.
;
;------------------------------------------------------------------------------
LCD_OFF:										; turn display off

		

		RET										; return from function


;==============================================================================
; @name:	LCD_CLR
; @description:
;  Clears the LCD-Display content.
;
;------------------------------------------------------------------------------
LCD_CLR:										; clears the display

		

		RET										; return from function

;==============================================================================
; @name:	LCD_RAM
; @description:
;  Sets the curser to the given RAM address. The RAM address defines where
;  on the display the content is put.
;
; @param <RAM_ADR>
;  The address to set the curser to.
;
;------------------------------------------------------------------------------
LCD_RAM:										; sets the ram address

		

		RET										; return from function

;==============================================================================
; @name:	LCD_CHR
; @description:
;  Writes a ascii character to the display.
;
; @param <CHAR>
;  The output char
;
;------------------------------------------------------------------------------
LCD_CHR:										; puts a char to the display

		

		RET										; return from function

;==============================================================================
; @name:	LCD_STR
; @description:
;  Writes a string to the display from the beginn address to the $00 char.
;
; @param *<STR>
;  The output string address
;
;------------------------------------------------------------------------------
LCD_STR:										; puts a string to the display

		

		RET										; return from function


;==============================================================================
; @name:	LCD_HEX
; @description:
;  Writes a hex number to the display.
;
; @param <HEX>
;  The output hex value
;
;------------------------------------------------------------------------------
LCD_HEX:										; outputs a hex value

		

		RET										; return from function

;==============================================================================
; @name:	LCD_INT16
; @description:
;  Writes a int16 number to the display.
;
; @param <INT16>
;  The output int16 value
;
;------------------------------------------------------------------------------
LLCD_INT16:										; outputs a int16 value

		

		RET										; return from function



