;===============================================================================
;- Programm:		    8BitTastencounterPunkt
;-
;- Dateinname:		    8BitTastencounterPunkt.asm
;- Version:			    1.0
;- Autor:			    Benj Fassbind
;-
;- Verwendungszweck:	uP-Schulung
;-
;- Beschreibung:
;-		
;-				
;-
;- Entwicklungsablauf:
;- Ver: Datum:	Autor:   Entwicklungsschritt:                         Zeit:
;- 1.0  20.10.13  FAB    Ganzes Programm erstellt				           Min.
;-
;-										Totalzeit:	 Min.
;-
;- Copyright: Benj Fassbind, Sonneggstrasse 13, 6410 Goldau (2013)
;------------------------------------------------------------------------------

;--- Kontrollerangabe ---
.include "../../../lib/m2560def.inc"

		RJMP	Reset



;--- Konstanten ---
.equ	LED		    = PORTB		; Ausgabeport fuer LED
.equ	LED_D	    = DDRB		; Daten Direction Port fuer LED

.equ	SWITCH	    = PIND		; Eingabeport fuer SWITCH
.equ	SWITCH_D	= DDRD		; Daten Direction Port fuer SWITCH

;--- Variablen ---
.def 	mpr	        = R16		; Multifunktionsregister
.def    punkt       = R17       ; Punkt Ausgabe



;------------------------------------------------------------------------------
; Hauptprogramm
;------------------------------------------------------------------------------

;--- Initialisierung ---
Reset:	SER	    mpr			        ; Output:= LED
		OUT	    LED_D, mpr

		CLR	    mpr			        ; Input:= Schalterwerte
		OUT	    SWITCH_D, mpr


;--- Hauptprogramm ---	
Main:	                            ; Main Function	
        CLR		punkt				;  punkt = $00
        SBR     punkt, $00          ;  punkt = $01
		IN		mpr, SWITCH			;  Switch einlesen
        COM     mpr                 ;  STK600 Spezifisch
	While:							;  While
		TST		mpr					;  if mpr == 0
		BREQ	End_While			;  Goto "End_While"			
		LSR		mpr					;   Shift mpr Right
		BRCC	Else				;   If carry = 0 goto Else
        TST     punkt               ;    If punkt <> 0 
        BRNE    ShiftPunktLeft      ;    goto ShiftPunktLeft
        INC     punkt               ;     Increment punkt
        RJMP    Else                ;     Goto Else
    ShiftPunktLeft:                 ;    Shift punkt left
		LSL		punkt				;    Shift punkt left
	Else:							;   Else
		RJMP	While				;  Loop
	End_While:						;  End_While
        COM     punkt               ;  STK600 Spezifisch
		OUT		LED, punkt			;  punkt auf LED ausgeben
		RJMP	Main				; Endless Loop
