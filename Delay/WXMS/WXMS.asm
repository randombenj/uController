;===============================================================================
;- Programm:		    WXMS
;-
;- Dateinname:		    WXMS.asm
;- Version:			    1.0
;- Autor:			    Benj Fassbind
;-
;- Verwendungszweck:	uP-Schulung
;-
;- Beschreibung:
;-	Ist eine Funktion welche X Milli-Sekunden wartet.
;-  X: anzahl Millisekunden (0-255)	
;-				
;-
;- Entwicklungsablauf:
;- Ver: Datum:	Autor:   Entwicklungsschritt:                         Zeit:
;- 1.0  01.01.13  FAB    Ganzes Programm erstellt				           Min.
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
.def    ms          = R17       ; Anzahl Millisekunden
.def    ms1         = R18       ; counter für 1 milli sekunde
.def    count       = R19       ; counter



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

        LDI     ms, $01             ;   <ms> = $0F

;--- Hauptprogramm ---	
Main:		                        ; [Main()] funtion
        OUT     LED, ms

        RCALL   W1MS                ;   WXMS(<ms>)

        ROL     ms
        RJMP    Main                ; GoTo: Main

;------------------------------------------------------------------------------
; Unterprogramme
;------------------------------------------------------------------------------
W1MS:                               ; [W1MS()] function

        PUSH    mpr                 ;   save <mpr> on stack
        IN      mpr, SREG           ;   <mpr> = *<SREG>
        PUSH    mpr                 ;   save *<SREG> on stack

        LDI     ms1, $10            
    WAIT:        

        LDI     mpr, $F8            ;   <mpr> = 248
    W248US:                         ;     W1US label
        NOP                         ;     no operation (1)
        DEC     mpr                 ;     <mpr>--
        BRNE    W248US              ;    if <z-bit> == 0: GoTo: W248US

        DEC     ms1
        BRNE    WAIT

        LDI     mpr, $0F            ;   <mpr> = 20 > 3 us
    W20US2:                         ;     W1US label
        NOP                         ;     no operation (1)
        DEC     mpr                 ;     <mpr>--
        BRNE    W20US2              ;    if <z-bit> == 0: GoTo: W20US

        POP     mpr                 ;   load *<SREG> from stack
        OUT     SREG, mpr           ;   *<SREG> = mpr
        POP     mpr                 ;   load <mpr> from stack
        nop

        RET                         ; return <void>