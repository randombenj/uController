;===============================================================================
;- Programm:		    DateTimeClock
;-
;- Dateinname:		    DateTimeClock.asm
;- Version:			    1.0
;- Autor:			    Benj Fassbind
;-
;- Verwendungszweck:	uP-Schulung
;-
;- Beschreibung:
;-	
;-  Eine Zeit-Datums Uhr mit folgenden werten	
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

;--- Include-Files ---
.include "H:\uQ\git\16.12.13\uController-master\lib\delay.inc"



;--- Konstanten ---
.equ	LED		    = PORTB		; Ausgabeport fuer LED
.equ	LED_D	    = DDRB		; Daten Direction Port fuer LED

.equ	SWITCH	    = PIND		; Eingabeport fuer SWITCH
.equ	SWITCH_D	= DDRD		; Daten Direction Port fuer SWITCH

;--- Variablen ---
.def 	mpr	        = R16		; Multifunktionsregister

;-- Zeit Variablen ---
.def    hh          = R17       ; Stunden Register
.def    mm          = R18       ; Minuten Register
.def    ss          = R19       ; Sekunden Register

.def    DD          = R20       ; Tag Register    
.def    MM          = R21       ; Monat Register
.def    YY          = R22       ; Jahr Register

.def    KW          = R23       ; KalenderWoche Register
.def    WD          = R24       ; WochenTag Register    


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
Main:		                        ;  [Main()] function
        
        RCALL   W100US              ;    W100US()
        RCALL   DT_Handle           ;    DT_Handle()

        RJMP    Main                ;  Endless Loop    

;------------------------------------------------------------------------------
; Unterprogramme
;------------------------------------------------------------------------------
DT_Handle:                          ;  [DT_Handle()] function
        
        

        RET                         ;  RETURN: <void>



