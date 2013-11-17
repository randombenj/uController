;===============================================================================
;- Programm:		    8BitTastencounterBalkenanzeige
;-
;- Dateinname:		    8BitTastencounterBalkenanzeige.asm
;- Version:			    1.0
;- Autor:			    Benj Fassbind
;-
;- Verwendungszweck:	uP-Schulung
;-
;- Beschreibung:
;-	Das Programm gibt auf den LEDs einen Balken au, je nachdem wie viele tasten
;-  gedrückt wurden.		
;-				
;-
;- Entwicklungsablauf:
;- Ver: Datum:	Autor:   Entwicklungsschritt:                         Zeit:
;- 1.0  19.10.13  FAB    Ganzes Programm erstellt				        20  Min.
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
.def	balken		= R17		; Balken Variable



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
		CLR		balken				;  Balken = $00
		IN		mpr, SWITCH			;  Switch einlesen
        COM     mpr                 ;  STK600 Spezifisch
	While:							;  While
		TST		mpr					;  if mpr == 0
		BREQ	End_While			;  Goto "End_While"			
		LSR		mpr					;   Shift mpr Right
		BRCC	Else				;   If carry == 0 goto Else
		ROL		balken				;    Rotate Balken left
	Else:							;   Else
		RJMP	While				;  Loop
	End_While:						;  End_While
        COM     balken              ;  STK600 Spezifisch
		OUT		LED, balken			;  Balken auf LED ausgeben
		RJMP	Main				; Endless Loop