;===============================================================================
;- Programm:			2x4BitTastencounter
;-
;- Dateinname:		    2x4BitTastencounter.asm
;- Version:			    1.0
;- Autor:			    Benj Fassbind
;-
;- Verwendungszweck:	uP-Schulung
;-
;- Beschreibung:
;-	Ein 2 mal 4 Bit tastencounter. Zählt die Tasten von jeweils 4 Switches
;-  und gibt diese danach auf 3 LEDs aus.	
;-				
;-
;- Entwicklungsablauf:
;- Ver: Datum:	Autor:   Entwicklungsschritt:                         Zeit:
;- 1.0  19.10.13  FAB    Ganzes Programm erstellt				        60  Min.
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
.def	output		= R17		; Output für LEDs
.def	count		= R18		; Eine Count Variable



;------------------------------------------------------------------------------
; Hauptprogramm
;------------------------------------------------------------------------------

;--- Initialisierung ---
Reset:	SER	    mpr			        ; Output:= LED
		OUT	    LED_D, mpr

		CLR	    mpr			        ; Input:= Schalterwerte
		OUT	    SWITCH_D, mpr


;--- Hauptprogramm ---	
Main:								; Main Function
		CLR		output				;  output = $00
		CLR		count				;  count = $00
		IN		mpr, SWITCH			;  Switch einlesen in mpr
        COM     mpr                 ;  stk600 spezifisch
	While:							;  While
		TST		mpr					;  ( mpr <= 0):
		BREQ	End_While			;  When false don't loop
		INC		count				;   count ++
        LSR		mpr					;   Shift mpr to the left
		BRCC	Else				;   Else if Carry cleared
		CPI		count, $05			;    if ( count >= $05):
		BRSH	IncHighByte			;	 Goto IncHighByte
		INC     output				;     Increment low Byte
        RJMP    IncHighByteEnd      ;     Goto IncHighByteEnd
	IncHighByte:					;	 Else IncHighByte
		SUBI    output, -$10		;     High Byte inkrmentieren.
    IncHighByteEnd:                 ;    IncHighByteEnd
	Else:							;	Else
		RJMP	While				;  Loop
	End_While:	    				;  End of the While loop
        COM     output              ;  stk600 spezifisch
		OUT		LED, output			;  ausgabe auf led
		RJMP	Main				; Endless Loop		

