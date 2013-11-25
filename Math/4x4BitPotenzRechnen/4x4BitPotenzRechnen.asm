;===============================================================================
;- Programm:			4x4BitPotenzRechnen
;-
;- Dateinname:		    4x4BitPotenzRechnen.asm
;- Version:			    1.0
;- Autor:			    Benj Fassbind
;-
;- Verwendungszweck:	uP-Schulung
;-
;- Beschreibung:
;-  Dieses Programm berechnet die Potenz zwier 4-Bit zahlen.
;-	> Also max: 15^15 = 	
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

// -- Variablen Deffinition der 16x16 Bit multiplikation.
.def    zahl1_lw_lb    = R20    ; Low Word Low Byte Zahl1
.def    zahl1_lw_hb    = R21    ; Low Word High Byte Zahl1
.def    zahl1_hw_lb    = R16    ; High Word Low Byte Zahl1
.def    zahl1_hw_hb    = R17    ; High Word High Byte Zahl1

.def    zahl2_lb	   = R22    ; Low Byte Zahl1
.def    zahl2_hb	   = R23    ; High Byte Zahl1

.def    res_lw_lb	   = R24    ; low Word Low Byte Resultat
.def    res_lw_hb	   = R25    ; Low Word High Byte Resultat
.def    res_hw_lb	   = R26    ; High Word Low Byte Resultat
.def    res_hw_hb	   = R27    ; High Word High Byte Resultat

.def    exp            = R28    ; Exponent
.def    base           = R29    ; Die Basis

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
Main:		                        ; Main Function
    
        CLR     res_hw_hb           ;  Resultat = 1
        CLR     res_hw_lb           ;  Resultat = 1
        CLR     res_lw_hb           ;  Resultat = 1
        LDI     res_lw_lb, $01      ;  Resultat = 1

        CLR     zahl1_lw_lb         ;  LWLB Zahl1 = 20
        CLR     zahl1_lw_hb         ;  LWHB Zahl1 = 30
        CLR     zahl1_hw_lb         ;  HWLB = 0
        CLR     zahl1_hw_hb         ;  HWHB = 0*/

        CLR     zahl2_lb
        CLR     zahl2_hb

        LDI     exp, $02            ;  Exponent = 2
        LDI     base, $04           ;  Basis = 4

        TST     exp                 ;  if exp != 0
        BRNE    ExpNotZero          ;   Goto: ExpZero
        RJMP    End_WhilePOW        ;   Calculated Power
    ExpNotZero:                     ;  Exponent ist nicht 0
        
        TST     base                ;  if base != 0
        BRNE    BaseNotZero         ;   Goto: BaseNotZero
        CLR     res_lw_lb           ;   Resultat = 0
        RJMP    End_WhilePOW        ;   Calculated Power
    BaseNotZero:                    ;  Basis ist nicht 0

    WhilePOW:                       ;  While loop
        TST     exp                 ;  If exp == 0
        BREQ    End_WhilePOW        ;  Goto End_WhilePOW
        DEC     exp                 ;   Exponent dekrementieren

        MOV     zahl1_lw_lb, res_lw_lb; LWLB Zahl1 = LWLB Resultat
        MOV     zahl1_lw_hb, res_lw_hb; LWHB Zahl1 = LWHB Resultat

        MOV     zahl2_lb, base      ;   Zahl2 = basis

        RCALL   Mult

        RJMP    WhilePOW            ;   Goto WhilePOW
    End_WhilePOW:                   ;  End of While Loop
        RJMP    Main                ; Endless Loop



;------------------------------------------------------------------------------
; Unterprogramme
;------------------------------------------------------------------------------


Mult:								; Multiplication function Function

        CLR     res_hw_hb           ;  Resultat = 1
        CLR     res_hw_lb           ;  Resultat = 1
        CLR     res_lw_hb           ;  Resultat = 1
        CLR     res_lw_lb           ;  Resultat = 1

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
        ROL     zahl1_hw_hb         ;   Rotiere zahl1 nach links.

        RJMP    While               ;  Loop
   While_false:                     ;  ende der While schlaufe

		RET							; Return