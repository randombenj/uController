;===============================================================================
;- Programm:		    16x16BitMultiplikation
;-
;- Dateinname:		    16x16BitMultiplikation.asm
;- Version:			    1.0
;- Autor:			    Benj Fassbind
;-
;- Verwendungszweck:	uP-Schulung
;-
;- Beschreibung:
;-  Dieses Prgramm multipliziert 2 16 - Bit Zahlen miteinander.
;-		
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
.def    mpr            = R28

.def    zahl1_lw_lb    = R20    ; Low Word Low Byte Zahl1
.def    zahl1_lw_hb    = R21    ; Low Word High Byte Zahl1
.def    zahl1_hw_lb    = R16    ; High Word Low Byte Zahl1
.def    zahl1_hw_hb    = R17    ; High Word High Byte Zahl1

.def    zahl2_lb    = R22       ; Low Byte Zahl1
.def    zahl2_hb    = R23       ; High Byte Zahl1

.def    res_lw_lb   = R24       ; low Word Low Byte Resultat
.def    res_lw_hb   = R25       ; Low Word High Byte Resultat
.def    res_hw_lb   = R26       ; High Word Low Byte Resultat
.def    res_hw_hb   = R27       ; High Word High Byte Resultat



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
        CLR     res_lw_lb           ;  Low Byte des Resultat = $00
        CLR     res_lw_hb           ;  Hight Byte des Resultats = $00
        CLR     res_hw_lb           ;  Low Byte des Resultat = $00
        CLR     res_hw_hb           ;  Hight Byte des Resultats = $00

        SBR     zahl2_lb, $00       ;  LB Zahl2 = 0
        SBR     zahl2_hb, $F0       ;  HB Zahl2 = 0

        SBR     zahl1_lw_lb, $00    ;  LWLB Zahl1 = 20
        SBR     zahl1_lw_hb, $F0    ;  LWHB Zahl1 = 30
        CLR     zahl1_hw_lb         ;  HWLB = 0
        CLR     zahl1_hw_hb         ;  HWHB = 0

    While:                          ;  While
        TST     zahl2_hb            ;  zahl2_lb > 0
        BREQ    TestLowByte         ;  Wenn true gehe teste das Low Byte
        RJMP    TestLowByteEnd      ;  Wenn false dann nicht weiter prüfen
   TestLowByte:                     ;  TestLowByte
        TST     zahl2_lb            ;  zahl2_lb > 0
        BREQ    While_false         ;  Wenn true dann nicht mehr loopen
   TestLowByteEnd:                  ;  Ende der prüfung

        LSR     zahl2_hb            ;   schiebe zahl2_hb nach rechts
        ROR     zahl2_lb            ;   Rotiere zahl2_lb nach rechts
        BRCC    Else                ;   Wenn carry = 0 dann zu else

        ADD     res_lw_lb, zahl1_lw_lb; LWLB resultat um LWLB Zahl1 erhöhen
        ADC     res_lw_hb, zahl1_lw_hb; LWHB resultat um LWHB zahl1 erhönen + Carry
        ADC     res_hw_lb, zahl1_hw_lb; HWLB resultat um HWLB zahl1 erhönen + Carry
        ADC     res_hw_hb, zahl1_hw_hb; HWHB resultat um HWHB zahl1 erhöhen + Carry
        
   Else:
        LSL     zahl1_lw_lb         ;   schiebe zahl1 nach links
        ROL     zahl1_lw_hb         ;   schiebe zahl1 nach links
        ROL     zahl1_hw_lb         ;   schiebe zahl1 nach links
        ROL     zahl1_hw_hb         ;   Rotiere mpr nach links.

        RJMP    While               ;  Loop
   While_false:                     ;  ende der While schlaufe
		RJMP	Main				; Endloschlaufe