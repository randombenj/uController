;******************************************************************************
;* Programm:		
;*
;* Dateinname:		    .asm
;* Version:			    1.0
;* Autor:			    Jan Leuenberger
;*
;* Verwendungszweck:	uP-Schulung
;*
;* Beschreibung:
;*		
;*				
;*
;* Entwicklungsablauf:
;* Ver: Datum:	Autor:   Entwicklungsschritt:                         Zeit:
;* 1.0  01.01.12  WOd    Ganzes Programm erstellt				           Min.
;*
;*										Totalzeit:	 Min.
;*
;* Copyright: Jan Leuenberger, Unterdorf 8, 5637 Beinwil Freiamt (2013)
;******************************************************************************

;*** Kontrollerangabe ***
.include "m8515def.inc"

		RJMP	Reset

;*** Include-Files ***
.include "U:\AVR Include Files\delay.inc"



;*** Konstanten ***
.equ	LED		    = PORTB		; Ausgabeport fuer LED
.equ	LED_D	    = DDRB		; Daten Direction Port fuer LED

.equ	SWITCH	    = PIND		; Eingabeport fuer SWITCH
.equ	SWITCH_D	= DDRD		; Daten Direction Port fuer SWITCH

;*** Variablen ***
.def 	mpr	        = R16		; Multifunktionsregister



;******************************************************************************
; Hauptprogramm
;******************************************************************************

;*** Initialisierung ***
Reset:	SER	    mpr			        ; Output:= LED
		OUT	    LED_D, mpr

		CLR	    mpr			        ; Input:= Schalterwerte
		OUT	    SWITCH_D, mpr

		LDI	    mpr, LOW(RAMEND)    ; Stack initialisieren
		OUT	    SPL,mpr
		LDI	    mpr, HIGH(RAMEND)
		OUT	    SPH,mpr


;*** Hauptprogramm ***	
Main:		



;******************************************************************************
; Unterprogramme
;******************************************************************************
