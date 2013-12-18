;===============================================================================
;- Programm:		    W1S
;-
;- Dateinname:		    W1S.asm
;- Version:			    1.0
;- Autor:			    Benj Fassbind
;-
;- Verwendungszweck:	uP-Schulung
;-
;- Beschreibung:
;-	Delay for 1 Second	
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
Main:	                            ; Main() function
        RCALL   W1S                 ;   W1S()
        RJMP    Main                ; GoTo: Main	



;------------------------------------------------------------------------------
; Unterprogramme
;------------------------------------------------------------------------------
W1S:                                ; W100MS() function

        PUSH    mpr                 ;   save <mpr> to stack
        IN      mpr, SREG           ;   <mpr> = <SREG>
        PUSH    mpr                 ;   save <SREG> to stack

        LDI     mpr, $09            ;   <mpr> = 10

    W1S_LOOP01:                     ;   LOOP:
        RCALL   W100MS              ;     W10MS()
        DEC     mpr                 ;     <mpr>--
        BRNE    W1S_LOOP01          ;   if <mpr> > 0: LOOP


        LDI     mpr, $09            ;   <mpr> = 10

    W1S_LOOP02:                     ;   LOOP:
        RCALL   W10MS               ;     W10MS()
        DEC     mpr                 ;     <mpr>--
        BRNE    W1S_LOOP02          ;   if <mpr> > 0: LOOP

        LDI     mpr, $09            ;   <mpr> = 10
    W1S_LOOP03:                 	;   LOOP:
        RCALL   W1MS                ;     W1MS()
        RCALL   W100US              ;     W100US()
        DEC     mpr                 ;     <mpr>--
        BRNE    W1S_LOOP03      	;   if <mpr> > 0: LOOP	

        LDI		mpr, $AF			;   <mpr> = 120
	W1S_LOOP04:                 	;   LOOP:
        NOP                         ;     wait 1 clock 
        DEC     mpr                 ;     <mpr>--
        BRNE    W1S_LOOP04      	;   if <mpr> > 0: LOOP	

        POP     mpr                 ;   loat <SREG> from stack
        OUT     SREG, mpr           ;   <SREG> = <mpr>
        POP     mpr                 ;   load <mpr> from stack

        RET                         ; return <void>


W100MS:                             ; W100MS() function

        PUSH    mpr                 ;   save <mpr> to stack
        IN      mpr, SREG           ;   <mpr> = <SREG>
        PUSH    mpr                 ;   save <SREG> to stack

        LDI     mpr, $09            ;   <mpr> = 10

    W100MS_LOOP01:                  ;   LOOP:
        RCALL   W10MS               ;     W10MS()
        DEC     mpr                 ;     <mpr>--
        BRNE    W100MS_LOOP01       ;   if <mpr> > 0: LOOP

        LDI     mpr, $09            ;   <mpr> = 10
    W100MS_LOOP02:                	;   LOOP:
        RCALL   W1MS                ;     W1MS()
        RCALL   W100US              ;     W100US()
        DEC     mpr                 ;     <mpr>--
        BRNE    W100MS_LOOP02      	;   if <mpr> > 0: LOOP	

        LDI		mpr, $B5			;   <mpr> = 120
	W100MS_LOOP03:                 	;   LOOP:
        NOP                         ;     wait 1 clock 
        DEC     mpr                 ;     <mpr>--
        BRNE    W100MS_LOOP03      	;   if <mpr> > 0: LOOP	
        
        // this is needed for accuracy
        NOP                         ;  wait 1 clock
        NOP                         ;  wait 1 clock
        NOP                         ;  wait 1 clock

        POP     mpr                 ;   loat <SREG> from stack
        OUT     SREG, mpr           ;   <SREG> = <mpr>
        POP     mpr                 ;   load <mpr> from stack

        RET                         ; return <void>


W10MS:								; function W1MS():

        PUSH    mpr                 ;   save <mpr> to stack
        IN      mpr, SREG           ;   <mpr> = <SREG>
        PUSH    mpr                 ;   save <SREG> to stack

		LDI		mpr, $63			;   <mp> = 99

	W10MS_LOOP01:					;	LOOP:
		RCALL	W100US				;     W100US()		
		DEC		mpr                 ;     <mpr>--
		BRNE	W10MS_LOOP01		;   if mpr > 0: GoTo: W1MS_LOOP01

		// this is needed for accuracy
		LDI		mpr, $79			;   <mpr> = 120
	W10MS_LOOP02:                  	;   LOOP:
        NOP                         ;     wait 1 clock 
        DEC     mpr                 ;     <mpr>--
        BRNE    W10MS_LOOP02       	;   if <mpr> > 0: LOOP	

		POP     mpr                 ;   loat <SREG> from stack
        OUT     SREG, mpr           ;   <SREG> = <mpr>
        POP     mpr                 ;   load <mpr> from stack

		RET                         ; return <void>


W1MS:								; function W1MS():

        PUSH    mpr                 ;   save <mpr> to stack
        IN      mpr, SREG           ;   <mpr> = <SREG>
        PUSH    mpr                 ;   save <SREG> to stack

		LDI		mpr, $09			;   <mp> = 9

	W1MS_LOOP01:					;	LOOP:
		RCALL	W100US				;     W100US()		
		DEC		mpr                 ;     <mpr>--
		BRNE	W1MS_LOOP01			;   if mpr > 0: GoTo: W1MS_LOOP01

		// this is needed for accuracy
		LDI		mpr, $BC			;   <mpr> = 188
	W1MS_LOOP02:                  	;   LOOP:
        NOP                         ;     wait 1 clock 
        DEC     mpr                 ;     <mpr>--
        BRNE    W1MS_LOOP02       	;   if <mpr> > 0: LOOP
        NOP                         ;   wait 1 clock
        NOP                         ;   wait 1 clock

		POP     mpr                 ;   loat <SREG> from stack
        OUT     SREG, mpr           ;   <SREG> = <mpr>
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
