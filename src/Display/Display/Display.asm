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

;------------------------------------------------------------------------------
; Interrupt-Adresse-Vectors

        RJMP   Reset            ; Ext-Pin, Power-on, Brown-out,Watchdog Reset
		NOP
        RETI                    ; External Interrupt Request 0
		NOP
        RETI                    ; External Interrupt Request 1
		NOP
        RETI                    ; External Interrupt Request 3
		NOP
        RETI                    ; External Interrupt Request 4
		NOP
        RETI                    ; External Interrupt Request 5
		NOP
        RETI                    ; External Interrupt Request 6
		NOP
        RETI                    ; External Interrupt Request 7
		NOP
        RETI                    ; Pin Change Interrupt Request 0
		NOP
        RETI                    ; Pin Change Interrupt Request 1
		NOP
        RETI                    ; Pin Change Interrupt Request 2
		NOP
        RETI                    ; Watchdog Time-out Interrupt
		NOP
        RETI                    ; Timer/Counter2 Compare Match A
		NOP
        RETI                    ; Timer/Counter2 Compare Match B
		NOP
        RETI                    ; Timer/Counter2 Overflow
		NOP
        RETI                    ; Timer/Counter1 Capture Event
		NOP
        RETI                    ; Timer/Counter1 Compare Match A
		NOP
        RETI                    ; Timer/Counter1 Compare Match B
		NOP
        RETI                    ; Timer/Counter1 Compare Match C
		NOP
        RETI                    ; Timer/Counter1 Overflow
		NOP
        RETI                    ; Timer/Counter0 Compare Match A
		NOP
        RETI                    ; Timer/Counter0 Compare Match B
		NOP
        RETI                    ; Timer/Counter0 Overflow
		NOP
        RETI                    ; SPI Serial Transfer Complete
		NOP
        RETI                    ; USART0 Rx Complete
		NOP
        RETI                    ; USART0 Data Register Empty
		NOP
        RETI                    ; USART0 Tx Complete
		NOP
        RETI                    ; Analog Comparator
		NOP

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



