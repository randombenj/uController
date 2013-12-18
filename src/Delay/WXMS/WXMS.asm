;===============================================================================
;- Programm:		    WXMS
;-
;- Dateinname:		    WXMS.asm
;- Version:			    1.0
;- Autor:			    Benj Fassbind
;-
;- Verwendungszweck:	uP-Schulung
;-
;- Beschreibung:
;-	Ist eine Funktion welche X Milli-Sekunden wartet.
;-  X: anzahl Millisekunden (0-255)	
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
.def    ms          = R17       ; Anzahl Millisekunden



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

        LDI     ms, $01             ;   <ms> = $0F

;--- Hauptprogramm ---	
Main:		                        ; [Main()] funtion
        OUT     LED, ms

        LDI     ms, $FF             ;   <ms> = 1
        RCALL   WXMS                ;   WXMS(<ms>)

        RJMP    Main                ; GoTo: Main

;------------------------------------------------------------------------------
; Unterprogramme
;------------------------------------------------------------------------------
WXMS:                               ; [WXMS(<ms>)] function

        PUSH    mpr                 ;   save <mpr> on stack
        IN      mpr, SREG           ;   <mpr> = *<SREG>
        PUSH    mpr                 ;   save *<SREG> on stack

        PUSH    ms                  ;   save <ms> on stack

    WXMS_LOOP01:                    ;   WXMS_LOOP01
        
        LDI		mpr, $0A			;     <mp> = 9
	WXMS_LOOP02:					;	  LOOP:
		RCALL	W100US				;       W100US()		
		DEC		mpr                 ;       <mpr>--
		BRNE	WXMS_LOOP02			;     if mpr > 0: GoTo: W1MS_LOOP01

        DEC     ms                  ;     <ms>--
        BRNE    WXMS_LOOP01         ;   if <ms> > 0: GoTo: WXMS_LOOP01

        POP     ms                  ;   load <ms> from stack

        POP     mpr                 ;   load *<SREG> from stack
        OUT     SREG, mpr           ;   *<SREG> = mpr
        POP     mpr                 ;   load <mpr> from stack

        RET                         ; return <void>


W100US:                             ; function W100US():

        PUSH    mpr                 ;   save <mpr> to stack
        IN      mpr, SREG           ;   <mpr> = <SREG>
        PUSH    mpr                 ;   save <SREG> to stack

        LDI     mpr, $C3            ;   <mpr> = 195

    W100US_LOOP01:                  ;   LOOP:
        NOP                         ;     wait 1 clock 
        DEC     mpr                 ;     <mpr>--
        BRNE    W100US_LOOP01       ;   if <mpr> > 0: LOOP

        // this is needed for accuracy
        NOP

        POP     mpr                 ;   loat <SREG> from stack
        OUT     SREG, mpr           ;   <SREG> = <mpr>
        POP     mpr                 ;   load <mpr> from stack

        RET                         ; return <void>