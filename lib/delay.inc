;===============================================================================
; Programm:				delay
;
; Dateinname:			delay.inc
; Version:				1.0.0
; Autor:				Benj Fassbind
;
; Verwendungszweck:		uP-Schulung
;
; Beschreibung:
;  
;  Delay loops for various times:
;				
;	- W100US
;	- W1MS
;	- W10MS
;	- W100MS
;	- W1S
;	- WXMS
;
; Entwicklungsablauf:
; Ver: Datum:	Autor:   Entwicklungsschritt:                         Zeit:
; 1.0  01.01.13  FAB    Ganzes Programm erstellt				    	Min.
;
;										Totalzeit:	 Min.
;
; Copyright: Benj Fassbind, Sonneggstrasse 13, 6410 Goldau (2013)
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Unterprogramme
;------------------------------------------------------------------------------
W100US:                             ; function W100US():

        PUSH    mpr                 ;   save <mpr> to stack
        IN      mpr, SREG           ;   <mpr> = <SREG>
        PUSH    mpr                 ;   save <SREG> to stack

        LDI     mpr, $C3            ;   <mpr> = 195

    LOOP:                           ;   LOOP:
        NOP                         ;     wait 1 clock 
        DEC     mpr                 ;     <mpr>--
        BRNE    LOOP                ;   if <mpr> > 0: LOOP

        // this is needed for accuracy
        NOP

        POP     mpr                 ;   loat <SREG> from stack
        OUT     SREG, mpr           ;   <SREG> = <mpr>
        POP     mpr                 ;   load <mpr> from stack

        RET                         ; return <void>

;------------------------------------------------------------------------------
; Unterprogramme
;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
; Unterprogramme
;------------------------------------------------------------------------------
W10MS:								; function W1MS():

        PUSH    mpr                 ;   save <mpr> to stack
        IN      mpr, SREG           ;   <mpr> = <SREG>
        PUSH    mpr                 ;   save <SREG> to stack

		LDI		mpr, $63			;   <mp> = 99

	W10MS_LOOP01:					;	LOOP:
		RCALL	W100US				;     W100US()		
		DEC		mpr                 ;     <mpr>--
		BRNE	W10MS_LOOP01		;   if mpr > 0: GoTo: W1MS_LOOP01
		
		LDI		mpr, $79			;   <mpr> = 120

        // this is needed for accuracy
	W10MS_LOOP02:                  	;   LOOP:
        NOP                         ;     wait 1 clock 
        DEC     mpr                 ;     <mpr>--
        BRNE    W10MS_LOOP02       	;   if <mpr> > 0: LOOP	

		POP     mpr                 ;   loat <SREG> from stack
        OUT     SREG, mpr           ;   <SREG> = <mpr>
        POP     mpr                 ;   load <mpr> from stack

		RET                         ; return <void>

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

;------------------------------------------------------------------------------
; Unterprogramme
;------------------------------------------------------------------------------
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
