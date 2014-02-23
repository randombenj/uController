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

.include "C:\Users\Beni\Documents\GitHub\uControllerNew\uController\lib\math.inc"

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
        
        LDI         dividend, 8
        LDI         divisor, 5
            
        RCALL       MOD
        
        OUT         LED, result

        RJMP        Main            


;------------------------------------------------------------------------------
; Unterprogramme
;------------------------------------------------------------------------------
MOD:                                ;  [MOD(<dividend>, <divisor>)] function
        // stack speichern: ---
        PUSH    dividend            ;    <dividend> auf stack speichern
        PUSH    divisor             ;    <divisor> auf stack speichern
        PUSH    mpr                 ;    <mpr> auf stack speichern

        // modulo: ---
        RCALL   DIV                 ;    <result> = DIV(<dividend>, <divisor>)
        MUL     result, divisor     ;    <R1:R0> = resultat * divisor
        SUB     dividend, R0        ;    <dividend> = <R0> - <dividend>

        CPI     dividend, $00       ;    if <dividend> > $00
        BRGE    MOD_ENDIF01         ;      GoTo: MOD_ENDIF01
        // wenn dividend negative make positive: ---
        NEG     dividend            ;      |<dividend>|
    MOD_ENDIF01:
        
        MOV     result, dividend    ;    <result> = <dividend>

        // stack laden: ---
        POP     mpr                 ;    <mpr> von stack laden
        POP     divisor             ;    <divisor> von stack laden
        POP     dividend            ;    <dividend> von stack laden

        RET                         ;  RETURN: <result>


