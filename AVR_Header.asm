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

;--- Kontrollerangabe ---
.include "m2560def.inc"

          RJMP     Reset

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
