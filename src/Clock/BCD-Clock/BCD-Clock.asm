;===============================================================================
;- Programm:		    BCD-Clock
;-
;- Dateinname:		    BCD-Clock.asm
;- Version:			    1.0
;- Autor:			    Benj Fassbind
;-
;- Verwendungszweck:	uP-Schulung
;-
;- Beschreibung:
;-		
;-	A BCD Second Clock wich shows the Seconds			
;-
;- Entwicklungsablauf:
;- Ver: Datum:	Autor:   Entwicklungsschritt:                         Zeit:
;- 1.0  01.01.13  FAB    Ganzes Programm erstellt				        90   Min.
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
.def	bcd			= R17		; Sekundenanzahl BCD Format


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

        CLR     bcd                ; <numb> = $00

;--- Hauptprogramm ---	
Main:   	                        ; Main() function

        RCALL   W100US             ;   W100US()
        
        INC     bcd                 ;   <bcd> ++
        
		SBRS	bcd, 1				;   <bcd[1]> == 1:
		RJMP	Main_ENDIF01		;    GoTo: Main_ENDIF01
		SBRS    bcd, 3				;   <bcd[3]> == 0:
		RJMP	Main_ENDIF01		;    GoTo: Main_ENDIF01
		
		SUBI	bcd, -$06			;     <bcd[HB]> inkrementieren

        CPI		bcd, $60		    ;     if <bcd> == $61:
		BRNE	Main_ENDIF02		;      GoTo: Main_ENDIF01
		
		CLR		bcd					;    <bcd> = $00
			
	Main_ENDIF01:					;   Main_ENDIF01

		
		COM		bcd
        OUT     LED, bcd            ;   <bcd> auf <SWITCH> ausgeben
		COM		bcd
        RJMP    Main                ; Endless loop