;******************************************************************************
;* Programm:			4x4BitMultiplikatioon		
;*
;* Dateinname:		    4x4BitMultiplikatioon.asm
;* Version:			    1.0
;* Autor:			    Benj Fassbind
;*
;* Verwendungszweck:	uP-Schulung
;*
;* Beschreibung:
;* > Das Programm multipliziert zwei 4-bit zahlen. 
;*   Zahl 1 > SW0 - SW3, Zahl 2 > SW4 - SW7
;*				
;*
;* Entwicklungsablauf:
;* Ver: Datum:	Autor:   Entwicklungsschritt:                         Zeit:
;* 1.0  19.10.13  FAB    Ganzes Programm erstellt				           Min.
;*
;*										Totalzeit:	 Min.
;*
;* Copyright: Benj Fassbind, Sonneggstr. 13, 6410 Goldau (2013)
;******************************************************************************

;*** Kontrollerangabe ***
.include "m2560def.inc"

		RJMP	Reset



;*** Konstanten ***
.equ	LED		    = PORTB		; Ausgabeport fuer LED
.equ	LED_D	    = DDRB		; Daten Direction Port fuer LED

.equ	SWITCH	    = PIND		; Eingabeport fuer SWITCH
.equ	SWITCH_D	= DDRD		; Daten Direction Port fuer SWITCH

;*** Variablen ***
.def 	mpr	        = R16		; Multifunktionsregister
.def	res			= R17		; Resultat
.def	zahl1		= R18		; Zahl1
.def	zahl2		= R19		; Zahl2



;******************************************************************************
; Hauptprogramm
;******************************************************************************

;*** Initialisierung ***
Reset:	SER	    mpr			        ; Output:= LED
		OUT	    LED_D, mpr

		CLR	    mpr			        ; Input:= Schalterwerte
		OUT	    SWITCH_D, mpr


;*** Hauptprogramm ***	
Main:								; Main Programm
		IN		mpr, SWITCH			;  Switches einlesen
        COM     mpr                 ;  stk600 spezifisch
        CLR     res                 ;  Resultat = $00
        MOV     zahl1, mpr          ;  zahl1 = mpr
        CBR     zahl1, $F0          ;  Nur 1. 4 bits gebraucht
        SWAP    mpr                 ;  Swap nibbles of mpr
        MOV     zahl2, mpr          ;  zahl2 = mpr
        CBR     zahl2, $F0          ;  Nur 1. 4 bits gebraucht
    While:                          ;  While
        TST     zahl2               ;  zahl2 > 0
        BREQ    While_false         ;  Wenn true dann nicht mehr loopen
        LSR     zahl2               ;   Rotiere zahl2 nach rechts
        BRCC    Else                ;   Wenn carry = 0 dann zu else
        ADD     res, zahl1          ;    Dem resultat um zahl1 erhöhen
   Else:                            ;   else
        ROL     zahl1               ;  Rotiere zahl1 nach rechts
        RJMP    While               ;  Loop
   While_false:                     ;  ende der While schlaufe
        COM     res                 ;  stk600 spezifisch
        OUT     LED, res            ;  Resultat ausgeben
		RJMP	Main				; Endloschlaufe