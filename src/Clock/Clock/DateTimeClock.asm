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
.include "C:\Users\Benj\workspace\GitHub\uController\lib\delay.inc"



;--- Konstanten ---
.equ	LED		    = PORTB		; Ausgabeport fuer LED
.equ	LED_D	    = DDRB		; Daten Direction Port fuer LED

.equ	SWITCH	    = PIND		; Eingabeport fuer SWITCH
.equ	SWITCH_D	= DDRD		; Daten Direction Port fuer SWITCH

;--- Variablen ---
.def 	mpr	        = R16		; Multifunktionsregister

;-- Date-time variables (ISO 8601: http://en.wikipedia.org/wiki/ISO_8601) ---

.def    hh          = R17       ; houers register
.def    mm          = R18       ; minutes register
.def    ss          = R19       ; seconds register

.def    DD          = R20       ; day register    
.def    MO          = R21       ; month register (because non key sensitive)
.def    YY          = R22       ; year register (two digits > 2000-2099)

.def    Www         = R23       ; calender week register (W01-W53)
.def    D           = R24       ; week day register (1-7)  

;-- Delay variables ---
.def    ms          = R25       ; milli seconds 


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
        
        // TODO: Calc <Www> and <D>

        // Calc time:   ---
        INC     ss                  ;    incrment <ss>
        CPI     ss, $3C             ;    if <ss> != 60:
        BRNE    DT_Handle_ENDIF1    ;     GoTo: DT_Handle_ENDIF1
        // Handle seconds: ---
        CLR     ss                  ;      <ss> = 0
        INC     mm                  ;      increment <mm>
        CPI     mm, $3C             ;      if <mm> != 60:
        BRNE    DT_Handle_ENDIF1    ;       GoTo: DT_Handle_ENDIF1
        // Handle minutes: ---
        CLR     mm                  ;        <mm> = 0
        INC     hh                  ;        increment <hh>
        CPI     hh, $18             ;        if <hh> != 24:
        BRNE    DT_Handle_ENDIF1    ;         GoTo: DT_Handle_ENDIF1
        // Handle houers: ---
        CLR     hh                  ;          <mm> = 0
        INC     DD                  ;          increment <hh>
        CPI     DD, $1C             ;          if <hh> != 28:
        BRNE    DT_Handle_ENDIF1    ;           GoTo: DT_Handle_ENDIF1
        // Handle months
        RCALL   DT_MM               ;            DT_MM(<DD>)
        CPI     MO, $0D             ;            if <MO> != 13:
        BRNE    DT_Handle_ENDIF1    ;             GoTo: DT_Handle_ENDIF1
        // Handle years: ---
        CLR     MO                  ;              <mm> = 0
        INC     YY                  ;              increment <hh>

    DT_Handle_ENDIF1:               ;  DT_Handle_ENDIF1
        RET                         ;  RETURN: <void>


DT_MM:                              ;  [DT_MM(<DD>)] function
        // Stack saving: ---
        PUSH    mpr                 ;  save <mpr> on stack

        CPI     MO, $02               ;  if <MO> != 2
        BRNE    DT_MM_ELSEIF1       ;   GoTo: DT_MM_ENDIF1
        // Handle all months except February: ---
        CPI     DD, $1D             ;    if <DD> < 29:
        BRLO    DT_MM_ENDIF1        ;     GoTo: DT_MM_ENDIF1
        // Handle if month has 30 or 31 Days
        CPI     MO, $07             ;      if <MO> < 7
        BRLO    DT_MM_ELSEIF4       ;       GoTo: DT_MM_ELSEIF4
        // Handle Jan-Jul: ---
        MOV     mpr, MO             ;        <mpr> = <MO>
        ASR     mpr                 ;        <mpr> = <mpr> / 2
        BRCC    DT_MM_30DAY         ;        if <carry-bit> = 0: GoTo: DT_MM_30DAY
        RJMP    DT_MM_31DAY         ;        else: GoTo: DT_MM_31DAY
    DT_MM_ELSEIF4:                  ;      DT_MM_ELSEIF4
        // Handle Aug-Dec: ---
        MOV     mpr, MO             ;        <mpr> = <MO>
        ASR     mpr                 ;        <mpr> = <mpr> / 2
        BRCS    DT_MM_30DAY         ;        if <carry-bit> = 1: GoTo: DT_MM_30DAY
        RJMP    DT_MM_31DAY         ;        else: GoTo: DT_MM_31DAY
    DT_MM_30DAY:                    ;      DT_MM_30DAY
        // The Month has 30 Days: ---
        LDI     DD, $01             ;        <DD> = 1
        INC     MO                  ;        increment <MO>
        RJMP    DT_MM_DAYEND        ;        GoTo: DT_MM_DAYEND
    DT_MM_31DAY:                    ;      DT_MM_31DAY
        // The Month has 31 Days: ---
        CPI      MO, $1E             ;        if <MO> < 30:
        BRLO    DT_MM_DAYEND        ;         GoTo: DT_MM_DAYEND
        LDI     DD, 1               ;          <DD> = 1
        INC     MO                  ;          increment <MO>
        RJMP    DT_MM_DAYEND        ;          GoTo: DT_MM_DAYEND
    DT_MM_DAYEND:                   ;      End Day calc
        RJMP    DT_MM_ENDIF1        ;  GoTo: DT_MM_ENDIF1
    DT_MM_ELSEIF1:                  ;  DT_MM_ELSEIF1
        // Handle February: ---
        MOV     mpr, YY             ;    <mpr> = <YY>
        ASR     mpr                 ;    <mpr> = <mpr> / 2
        BRCS    DT_MM_ELSEIF2       ;    if <carry-bit> == 2: GoTo: DT_MM_ELSEIF2
        ASR     mpr                 ;    <mpr> = <mpr> / 2
        BRCS    DT_MM_ELSEIF2       ;    if <carry-bit> == 2: GoTo: DT_MM_ELSEIF2
        // Handle leap year: ---
        CPI     DD, $1D             ;      if <DD> == 29:
        BRNE    DT_MM_ENDIF3        ;       GoTo: DT_MM_ENDIF3
        // Wayt one more Day (because of leap year): ---
        LDI     DD, $01             ;        <DD> = 1
        INC     MO                  ;        increment <MO>
    DT_MM_ENDIF3:                   ;      DT_MM_ENDIF3
        RJMP    DT_MM_ENDIF2        ;    GoTo: DT_MM_ENDIF2
    DT_MM_ELSEIF2:                  ;    DT_MM_ELSEIF2
        // Handle non leap year: ---
        LDI     DD, $01             ;      <DD> = 1
        INC     MO                  ;      increment <MO>
    DT_MM_ENDIF2:                   ;    DT_MM_ENDIF2
    DT_MM_ENDIF1:                   ;  DT_MM_ENDIF1
        // Stack loading: ---
        POP     mpr                 ;  load <mpr> from stack
        RET                         ;  RETURN: <void>



