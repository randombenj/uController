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
        RETI                    ; External Interrupt Request 0
        RETI                    ; External Interrupt Request 1
        RETI                    ; External Interrupt Request 3
        RETI                    ; External Interrupt Request 4
        RETI                    ; External Interrupt Request 5
        RETI                    ; External Interrupt Request 6
        RETI                    ; External Interrupt Request 7
        RETI                    ; Pin Change Interrupt Request 0
        RETI                    ; Pin Change Interrupt Request 1
        RETI                    ; Pin Change Interrupt Request 2
        RETI                    ; Watchdog Time-out Interrupt
        RETI                    ; Timer/Counter2 Compare Match A
        RETI                    ; Timer/Counter2 Compare Match B
        RETI                    ; Timer/Counter2 Overflow
        RETI                    ; Timer/Counter1 Capture Event
        RETI                    ; Timer/Counter1 Compare Match A
        RETI                    ; Timer/Counter1 Compare Match B
        RETI                    ; Timer/Counter1 Compare Match C
        RETI                    ; Timer/Counter1 Overflow
        RETI                    ; Timer/Counter0 Compare Match A
        RETI                    ; Timer/Counter0 Compare Match B
        RETI                    ; Timer/Counter0 Overflow
        RETI                    ; SPI Serial Transfer Complete
        RETI                    ; USART0 Rx Complete
        RETI                    ; USART0 Data Register Empty
        RETI                    ; USART0 Tx Complete
        RETI                    ; Analog Comparator

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
Main:          



;------------------------------------------------------------------------------
; Subroutines
;------------------------------------------------------------------------------
