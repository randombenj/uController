;===============================================================================
;- Programm:		    8x8BitDivision
;-
;- Dateinname:		    8x8BitDivision.asm
;- Version:			    1.0
;- Autor:			    Benj Fassbind
;-
;- Verwendungszweck:	uP-Schulung
;-
;- Beschreibung:
;-	Das Programm führt eine Division zwischen zwei 8 Bit Zahlen durch.	
;-				
;-
;- Entwicklungsablauf:
;- Ver: Datum:	Autor:   Entwicklungsschritt:                         Zeit:
;- 1.0  17.11.13  FAB    Ganzes Programm erstellt				           Min.
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
.def    dividend    = R17       ; Dividend
.def    divisor     = R18       ; Divisor
.def    result      = R19       ; Resultat



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
Main:	                            ; Main function

        // Data Initialisation
        LDI     dividend, $15       ;   <dividend> = 0b10101
        LDI     divisor, $05        ;   <dividend> = 0b101
        CLR     result              ;   <result> = $00
        CLR     mpr                 ;   <mpr> = $00

        TST     dividend            ;   if <dividend> == 0
        BREQ    DevByZero           ;     "devide by zero"

    While:                          ;   While 
        TST     dividend            ;    <dividend> == 0
        BREQ    EndWhile            ;    Goto: EndWhile

        CLC                         ;     Clear <c-bit>
        LSL     result              ;     <result> = <result> << 1

        LSL     dividend            ;     <dividend> = <dividend> << 1
        ROL     mpr                 ;     Rotate <mpr> Right
        
        CP      mpr, divisor        ;     <mpr> >= <divisor>
        BRLO    EndSub              ;      Goto: EndSub

        INC     result              ;         <result> = <result> << 1
        SUB     mpr, divisor        ;         <mpr> = <mpr> - <divisor>
    EndSub:                         ;       EndSub
        RJMP    While               ;     Loop  
    EndWhile:                       ;   End While loop
  DevByZero:                        ;   Devide by zero
        RJMP    Main                ; Endless loop    	
    


;------------------------------------------------------------------------------
; Unterprogramme
;------------------------------------------------------------------------------
