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
.def    zahl1       = R20       ; 1. Zahl
.def    zahl2       = R21       ; 2. Zahl
.def    res_lb      = R22       ; Low Byte des Resultats
.def    res_hb      = R23       ; High Byte des Resultats



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
        CLR     zahl1               ;  Zahl1 = $00
        CLR     zahl2               ;  Zahl2 = $00
        CLR     mpr                 ;  mpr = $00
        SBR     zahl1, $14          ;  Zahl1 = 20
        SBR     zahl2, $1E          ;  Zahl2 = 30
    While:                          ;  While
        TST     zahl2               ;  zahl2 > 0
        BREQ    While_false         ;  Wenn true dann nicht mehr loopen
        LSR     zahl2               ;   Rotiere zahl2 nach rechts
        BRCC    Else                ;   Wenn carry = 0 dann zu else
        ADD     res_hb, mpr         ;    High-Byte um mpr erhöhen
        ADD     res_lb, zahl1       ;    Dem resultat um zahl1 erhöhen
        BRCC    Else                ;    Wenn z = 0 dann zu else
        INC     res_hb              ;     Sonst High-Byte inkrementieren
   Else:                            ;   else
        LSL     zahl1               ;  schiebe zahl1 nach links
        ROL     mpr                 ;  Rotiere mpr nach links.
        RJMP    While               ;  Loop
   While_false:                     ;  ende der While schlaufe
		RJMP	Main				; Endloschlaufe
        		



