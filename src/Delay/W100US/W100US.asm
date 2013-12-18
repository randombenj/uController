;===============================================================================
;- Programm:		    W100US
;-
;- Dateinname:		    W100US.asm
;- Version:			    1.0
;- Autor:			    Benj Fassbind
;-
;- Verwendungszweck:	uP-Schulung
;-
;- Beschreibung:
;-	ATMega2560@8MHz Delay schlaufe von 100 mikro Sekunden	
;-				
;-
;- Entwicklungsablauf:
;- Ver: Datum:	Autor:   Entwicklungsschritt:                         Zeit:
;- 1.0  8.12.13  FAB    Ganzes Programm erstellt				           Min.
;-
;-										Totalzeit:	 Min.
;-
;- Copyright: Benj Fassbind, Sonneggstrasse 13, 6410 Goldau (2013)
;------------------------------------------------------------------------------

;--- Kontrollerangabe ---
.include "m2560def.inc"

		RJMP	Reset



;--- Konstanten ---
.equ	LED		    = PORTB		; Ausgabeport fuer LED
.equ	LED_D	    = DDRB		; Daten Direction Port fuer LED

.equ	SWITCH	    = PIND		; Eingabeport fuer SWITCH
.equ	SWITCH_D	= DDRD		; Daten Direction Port fuer SWITCH

;--- Variablen ---
.def 	mpr	        = R16		; Multifunktionsregister



;------------------------------------------------------------------------------
; Hauptprogramm
;------------------------------------------------------------------------------

;--- Initialisierung ---
Reset:	SER	    mpr			        ; Output:= LED
		OUT	    LED_D, mpr

		CLR	    mpr			        ; Input:= Schalterwerte
		OUT	    SWITCH_D, mpr

		LDI	    mpr, LOW(RAMEND)    ; Stack initialisieren
		OUT	    SPL,mpr
		LDI	    mpr, HIGH(RAMEND)
		OUT	    SPH,mpr


;--- Hauptprogramm ---	
Main:		                        ; function Main():
        
        RCALL   W100US              ;   W100US()

        RJMP    Main                ; GoTo: Main()



;------------------------------------------------------------------------------
; Unterprogramme
;------------------------------------------------------------------------------
W100US:                             ; function W100US():

        PUSH    mpr                 ;   save <mpr> to stack
        IN      mpr, SREG           ;   <mpr> = <SREG>
        PUSH    mpr                 ;   save <SREG> to stack

        LDI     mpr, $C3            ;   <mpr> = 195

    LOOP:                           ;   LOOP:
        NOP                         ;     wait 1 clock 
        DEC     mpr                 ;     <mpr>--
        BRNE    LOOP                ;   if <mpr> > 0: LOOP

        // this is needed for accuracy
        NOP

        POP     mpr                 ;   loat <SREG> from stack
        OUT     SREG, mpr           ;   <SREG> = <mpr>
        POP     mpr                 ;   load <mpr> from stack

        RET                         ; return <void>
