;===============================================================================
;- Programm:		    8x8BitMultiplikation
;-
;- Dateinname:		    8x8BitMultiplikation.asm
;- Version:			    1.0
;- Autor:			    Benj Fassbind
;-
;- Verwendungszweck:	uP-Schulung
;-
;- Beschreibung:
;-  Dieses Programm multipliziert zwei 8-bit zahlen miteinander.
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
.def    zahl1_lb    = R20       ; 1. Zahl Low Byte
.def    zahl1_hb    = R21       ; 1. Zahl Hight Byte
.def    zahl2       = R22       ; 2. Zahl
.def    res_lb      = R23       ; Low Byte des Resultats
.def    res_hb      = R24       ; High Byte des Resultats



;------------------------------------------------------------------------------
; Hauptprogramm
;------------------------------------------------------------------------------

;--- Initialisierung ---
Reset:	SER	    mpr			        ; Output:= LED
		OUT	    LED_D, mpr

		CLR	    mpr			        ; Input:= Schalterwerte
		OUT	    SWITCH_D, mpr


;--- Hauptprogramm ---	
Main:                               ; Main Function
        CLR     res_lb              ;  Low Byte des Resultat = $00
        CLR     res_hb              ;  Hight Byte des Resultats = $00
        CLR     zahl1_lb            ;  Zahl1 = $00
        CLR     zahl2               ;  Zahl2 = $00
        CLR     zahl1_hb            ;  Zahl1 High Byte = $00
        SBR     zahl1_lb, $14       ;  Zahl1 Low Byte = 20
        SBR     zahl2, $1E          ;  Zahl2 = 30
    While:                          ;  While
        TST     zahl2               ;  zahl2 > 0
        BREQ    EndWhile            ;  Wenn true dann nicht mehr loopen
        LSR     zahl2               ;   Rotiere zahl2 nach rechts
        BRCC    Else                ;   Wenn carry = 0 dann zu else
        ADD     res_lb, zahl1_lb    ;    Dem resultat um zahl1 LB erhöhen
        ADC     res_hb, zahl1_hb    ;    High-Byte um Zahl1 High Byte erhöhen + carry
   Else:                            ;   else
        LSL     zahl1_lb            ;  schiebe zahl1 nach links
        ROL     zahl1_hb            ;  Rotiere mpr nach links.
        RJMP    While               ;  Loop
   EndWhile:                        ;  ende der While schlaufe
		RJMP	Main				; Endloschlaufe
        		



