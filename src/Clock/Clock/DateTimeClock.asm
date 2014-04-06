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
;-  Eine Zeit-Datums Uhr auf Assembler Basis
;-
;- Copyright: Benj Fassbind, Sonneggstrasse 13, 6410 Goldau (2014)
;------------------------------------------------------------------------------

;--- Kontrollerangabe ---
.include "m2560def.inc"

        RJMP   Reset            ; Ext-Pin, Power-on, Brown-out,Watchdog Reset
.org    0x46
        RJMP   Tc0i


;--- Include-Files ---
.include "..\..\..\lib\math.inc"



;--- Konstanten ---
.equ	LED		    = PORTB		; Ausgabeport fuer LED
.equ	LED_D	    = DDRB		; Daten Direction Port fuer LED

.equ	SWITCH	    = PIND		; Eingabeport fuer SWITCH
.equ	SWITCH_D	= DDRD		; Daten Direction Port fuer SWITCH

.equ    MHz         = $04       ; MCU getaktet mit 8 MHz
.equ    MaxCount    = $7A12     ; Vorteiler des Zaehlers = 256 
                                ; => 8MHz/256 = 31250 Hz = $7A12

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

;-- math.inc variables: ---
.def    dividend    = R25       ; the dividend
.def    divisor     = R26       ; the divisor
.def    result      = R27       ; the result


;-- Delay variables ---
.def    ms          = R25       ; milli seconds 

;-- TC variables ---
.def    count       = R28       ; MSB-count, SW-count


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

        ; Timer 0 initialisieren:
        LDI     mpr, MHz            ;  Initiate Timer/Counter 0 Vorteiler
        OUT     TCCR0B, mpr         ;  to timer interupt mask register

        ; Swich timer 0 interup on:
        LDI     mpr, (1<<TOIE0)     ; Swich bit1 on
        STS     TIMSK0, mpr         ; in timer interupt mask register

        ; software count register = $00
        CLR     count               ; software count = $00
        CLR     SS                  ; seconds = $00

		; set interupts globaly
		SEI							; sets interupts globaly

        ; set beginn datetime
        LDI     MM, 22
        LDI     HH, 20
        LDI     DD, 7
        LDI     MO, 4
        LDI     YY, 14

;--- Hauptprogramm ---	
Main:		                        ;  [Main()] function
        
    Main_LOOP01:
        RCALL   Out_Handle          ;    Handle output
        CPI     count, HIGH(MaxCount)
        BRLT    Main_LOOP01         ;    count < $7A: wait longer

    Main_LOOP02:
        IN      mpr, TCNT0          ;    read count LSB
        CPI     mpr, LOW(MaxCount)
        BRLT    Main_LOOP02         ;    mpr < $12: wait longer

        CLR     mpr                 ;    mpr = $00
        OUT     TCNT0, mpr          ;    $00 in hardware counter LSB
        CLR     count               ;    count = $00 (MSB)

        RCALL   DT_Handle           ;    DT_Handle()

        RJMP    Main                ;  Endless Loop    

;------------------------------------------------------------------------------
; Unterprogramme
;------------------------------------------------------------------------------
;===============================================================================
; @name:             Out_Handle
; @description:
;   Handles the output of the datetime
;
;------------------------------------------------------------------------------
Out_Handle:                         ; [Out_Handle(<count>)] function

        IN      mpr, SWITCH         ;  read SWITCH
        COM     mpr                 ; invert (device specific)


        TST     mpr                 ;  if at least one button pressed
        BRNE    Out_HandleIF01      ;  goto

        COM     SS                  ;   prepare <SS> for output
        OUT     LED, SS             ;   set LED to <SS>
        COM     SS                  ;   undo the preparation.

        RJMP    Out_HandleENDIF01
    Out_HandleIF01:

        SBRS    mpr, 0              ;  if <SWITCH[0]> is not pressed
        RJMP    Out_HandleELSEIF01  ;  else if

        COM     SS                  ;   prepare <SS> for output
        OUT     LED, SS             ;   set LED to <SS>
        COM     SS                  ;   undo the preparation.

    Out_HandleELSEIF01:
        SBRS    mpr, 1              ;  if <SWITCH[1]> is not pressed
        RJMP    Out_HandleELSEIF02  ;  else if
        
        COM     MM                  ;   prepare <MM> for output
        OUT     LED, MM             ;   set LED to <MM>
        COM     MM                  ;   undo the preparation

    Out_HandleELSEIF02:
        SBRS    mpr, 2              ;  if <SWITCH[2]> is not pressed
        RJMP    Out_HandleELSEIF03  ;  else if
        
        COM     HH                  ;   prepare <HH> for output
        OUT     LED, HH             ;   set LED to <HH>
        COM     HH                  ;   undo the preparation

    Out_HandleELSEIF03:
        SBRS    mpr, 3              ;  if <SWITCH[3]> is not pressed
        RJMP    Out_HandleELSEIF04  ;  else if
        
        COM     DD                  ;   prepare <DD> for output
        OUT     LED, DD             ;   set LED to <DD>
        COM     DD                  ;   undo the preparation

    Out_HandleELSEIF04:
        SBRS    mpr, 4              ;  if <SWITCH[4]> is not pressed
        RJMP    Out_HandleELSEIF05  ;  else if
        
        COM     MO                  ;   prepare <MO> for output
        OUT     LED, MO             ;   set LED to <MO>
        COM     MO                  ;   undo the preparation

    Out_HandleELSEIF05:
        SBRS    mpr, 5              ;  if <SWITCH[3]> is not pressed
        RJMP    Out_HandleENDIF01   ;  endif
        
        COM     YY                  ;   prepare <YY> for output
        OUT     LED, YY             ;   set LED to <YY>
        COM     YY                  ;   undo the preparation

    Out_HandleENDIF01:
        
        RET                         ; Return from function


;===============================================================================
; @name:             Tc0i
; @description:
;   Handles Timer counter 0 overflow
;
;------------------------------------------------------------------------------
Tc0i:                               ; [Tc0i(<count>)] function
        
        PUSH    mpr                 ; save mpr to stack
        IN      mpr, SREG           ; save SREG
        INC     count               ; increment count register
        OUT     SREG, mpr           ; load SREG
        POP     mpr                 ; load mpr from stack

        RETI                        ; return from interupt


;===============================================================================
; @name:             DT_Handle
; @description:
;   Handles the date-time clock
;
;------------------------------------------------------------------------------
DT_Handle:                          ;  [DT_Handle()] function
        
        // TODO: Calc <Www> and <D>
        RCALL   Get_D               ;    calc day of week
        RCALL   Get_Www             ;    calc weeknumber

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

;===============================================================================
; @name:             SW_Handle
; @description:
;   Handles the summer and winter time houer increment or decrement:
;
; @param <DD>:
;  the day of the date
; @param <MO>:
;  the month of the date
; @param *<hh>:
;  the hour of the date
; @param <D>:
;  the weekday
;------------------------------------------------------------------------------
SW_Handle:                          ;  [SW_Handle()] function
        // stack saving: ---
        PUSH    dd                  ;  save <dd> on stack
        PUSH    MO                  ;  save <MO> on stack
        PUSH    D                   ;  save <D> on stack
        PUSH    mpr                 ;  save <mpr> on stack
        // summer winter time correction: --
        CPI     MO, $03             ;  if <MO> is March
        BRNE    SW_HandleELSEIF01   ;   else if: SW_HandleELSEIF01
        // summer time: ---
        CPI     HH, $02             ;   if <HH> = 2:00
        BRNE    SW_HandleENDIF01    ;    endif
        // the last sunday in the month: ---
        CPI     D, $00              ;     if <D> = sunday
        BRNE    SW_HandleENDIF01    ;      endif
        LDI     mpr, 31             ;       <mpr> = 31
        SUB     mpr, DD             ;       31 - <DD> => if last sunday
        CPI     mpr, $07            ;       if not last sunday:
        BRGE    SW_HandleENDIF01    ;        endif
        // summer time: ---
        INC     hh                  ;         set summer time
    SW_HandleELSEIF01:
        CPI     MO, $0A             ;  if <MO> is October
        BRNE    SW_HandleENDIF01    ;   endif: SW_HandleENDIF01
        // winter time: ---
        CPI     HH, $03             ;   if <HH> = 3:00
        BRNE    SW_HandleENDIF01    ;    endif
        // the last sunday in the month: ---
        CPI     D, $00              ;     if <D> = sunday
        BRNE    SW_HandleENDIF01    ;      endif
        LDI     mpr, 31             ;       <mpr> = 31
        SUB     mpr, DD             ;       31 - <DD> => if last sunday
        CPI     mpr, $07            ;       if not last sunday:
        BRGE    SW_HandleENDIF01    ;        endif
        // winter time (if not allready set): ---
        BRTS    SW_HandleELSEID02   ;         if <t-flag> set
        // winter time: ---
        DEC     hh                  ;           set winter time
        SET                         ;           set <t-flag>
        RJMP    SW_HandleENDIF01    ;           endif
    SW_HandleELSEID02:
        CLT                         ;           set <t-flag>
    SW_HandleENDIF01:
        // stack loading: ---
        POP     mpr                 ;  load <mpr> from stack
        PUSH    D                   ;  load <D> from stack
        POP     MO                  ;  load <MO> from stack
        POP     dd                  ;  load <dd> from stack
        RET                         ;  RETURN <void>


;===============================================================================
; @name:             GET_D
; @description:
;   Calculates the day of the week (0-6):
;
; @param <DD>:
;  the day of the date
; @param <MO>:
;  the month of the date
; @param <YY>:
;  the year of the date
; @return <result>:
;  the result week day (0-6)
;------------------------------------------------------------------------------
GET_D:                              ;  [GET_D(<DD>, <MO>, <YY>)] function
        // stack saving: ---        
        PUSH    dd                  ;  save <dd> on stack
        PUSH    MO                  ;  save <MO> on stack
        PUSH    YY                  ;  save <YY> on stack
        PUSH    mpr                 ;  save <mpr> on stack
        // calc. year-offset: ---
        MOV     mpr, YY             ;  <mpr> = <YY>
        PUSH    mpr                 ;  save original year on stack
        ASR     mpr                 ;  <mpr> = <mpr> / 2
        ASR     mpr                 ;  <mpr> = <mpr> / 2
        ADD     YY, mpr             ;  <YY> = <YY> + <mpr>
        MOV     dividend, YY        ;  <dividend> = <YY>
        LDI     divisor, $07        ;  <divisor> = 7
        RCALL   MOD                 ;  <result> = MOD(<dividend>, <divisor>)
        MOV     YY, result          ;  <YY> = <result>
        POP     mpr                 ;  load original year from stack
        // leap year: ---
        ASR     mpr                 ;    <mpr> = <mpr> / 2
        BRCS    GET_D_ELSEIF2      ;    if <carry-bit> == 2: GoTo: GET_D_ELSEIF01
        ASR     mpr                 ;    <mpr> = <mpr> / 2
        BRCS    GET_D_ELSEIF2      ;    if <carry-bit> == 2: GoTo: GET_D_ELSEIF01
        // handle leap year: ---
        DEC     YY                  ;    <YY> = <YY> - 1
    GET_D_ELSEIF2:                  ;    GET_D_ELSEIF2
        // calc. month-offset: ---
        CPI     MO, $01             ;  case <MO> =  1
        BRNE    GET_D_CASE_02       ;    else: GoTo: GET_D_CASE_02
        // January
        LDI     MO, $00             ;    <MO> = 0;
        RJMP    GET_D_ENDSWICH01    ;    break
    GET_D_CASE_02:
        CPI     MO, $02             ;  case <MO> =  2
        BRNE    GET_D_CASE_03       ;    else: GoTo: GET_D_CASE_03
        // February
        LDI     MO, $03             ;    <MO> = 3;
        RJMP    GET_D_ENDSWICH01    ;    break
    GET_D_CASE_03:
        CPI     MO, $03             ;  case <MO> =  3
        BRNE    GET_D_CASE_04       ;    else: GoTo: GET_D_CASE_04
        // March
        LDI     MO, $03             ;    <MO> = 3;
        RJMP    GET_D_ENDSWICH01    ;    break
    GET_D_CASE_04:
        CPI     MO, $04             ;  case <MO> =  4
        BRNE    GET_D_CASE_05       ;    else: GoTo: GET_D_CASE_05
        // April
        LDI     MO, $06             ;    <MO> = 6;
        RJMP    GET_D_ENDSWICH01    ;    break
    GET_D_CASE_05:
        CPI     MO, $05             ;  case <MO> =  5
        BRNE    GET_D_CASE_06       ;    else: GoTo: GET_D_CASE_06
        // May
        LDI     MO, $01             ;    <MO> = 1;
        RJMP    GET_D_ENDSWICH01    ;    break
    GET_D_CASE_06:
        CPI     MO, $06             ;  case <MO> =  6
        BRNE    GET_D_CASE_07       ;    else: GoTo: GET_D_CASE_07
        // June
        LDI     MO, $04             ;    <MO> = 4;
        RJMP    GET_D_ENDSWICH01    ;    break
    GET_D_CASE_07:
        CPI     MO, $07             ;  case <MO> =  7
        BRNE    GET_D_CASE_08       ;    else: GoTo: GET_D_CASE_08
        // July
        LDI     MO, $06             ;    <MO> = 6;
        RJMP    GET_D_ENDSWICH01    ;    break
    GET_D_CASE_08:
        CPI     MO, $08             ;  case <MO> =  8
        BRNE    GET_D_CASE_09       ;    else: GoTo: GET_D_CASE_09
        // August
        LDI     MO, $02             ;    <MO> = 2;
        RJMP    GET_D_ENDSWICH01    ;    break
    GET_D_CASE_09:
        CPI     MO, $09             ;  case <MO> =  9
        BRNE    GET_D_CASE_10       ;    else: GoTo: GET_D_CASE_10
        // September
        LDI     MO, $05             ;    <MO> = 5;
        RJMP    GET_D_ENDSWICH01    ;    break
    GET_D_CASE_10:
        CPI     MO, $0A             ;  case <MO> =  10
        BRNE    GET_D_CASE_11       ;    else: GoTo: GET_D_CASE_11
        // October
        LDI     MO, $00             ;    <MO> = 0;
        RJMP    GET_D_ENDSWICH01    ;    break
    GET_D_CASE_11:
        CPI     MO, $0B             ;  case <MO> =  11
        BRNE    GET_D_CASE_12       ;    else: GoTo: GET_D_CASE_12
        // November
        LDI     MO, $03             ;    <MO> = 3;
        RJMP    GET_D_ENDSWICH01    ;    break
    GET_D_CASE_12:
        CPI     MO, $0C             ;  case <MO> =  12
        BRNE    GET_D_ENDSWICH01    ;    else: GoTo: GET_D_ENDSWICH01
        // December
        LDI     MO, $05             ;    <MO> = 5;
        RJMP    GET_D_ENDSWICH01    ;    break
    GET_D_ENDSWICH01:               ;  end of swich 01
        // calc day-offset: ---
        MOV     dividend, DD        ;  <dividend> = <DD>
        LDI     divisor, $07        ;  <divisor> = 7
        RCALL   MOD                 ;  <result> = MOD(<dividend>, <divisor>)
        MOV     DD, result          ;  <DD> = <result>
        // calculate the day of the week: ---
        CLR     mpr                 ;  <mpr> = $00
        SUBI    mpr, -$06           ;  <mpr> = <mpr> + 6 > century-offset
        ADD     mpr, YY             ;  <mpr> = <mpr> + <YY> > year-offset
        ADD     mpr, MO             ;  <mpr> = <mpr> + <MO> > month-offset 
        ADD     mpr, DD             ;  <mpr> = <mpr> + <DD> > day-offset

        MOV     dividend, mpr       ;  <dividend> = <DD>
        LDI     divisor, $07        ;  <divisor> = 7
        RCALL   MOD                 ;  <result> = MOD(<dividend>, <divisor>)

        MOV     D, result           ;  <D> = result

        // stack loading: ---
        POP     mpr                 ;  load <mpr> from stack
        POP     YY                  ;  load <YY> from stack
        POP     MO                  ;  load <MO> from stack
        POP     dd                  ;  load <dd> from stack
        RET                         ;  RETURN <result>

;===============================================================================
; @name:             GET_Www
; @description:
;   Calculates the the week number (0-53):
;
; @param <MO>:
;  the month of the current date
; @param <DD>:
;  the days of the current month
; @return <Www>:
;  the week number
;------------------------------------------------------------------------------
GET_Www:                            ;  [GET_Www(<MO>, <DD>)] function
        // stack saving: ---        
        PUSH    dd                  ;    save <dd> on stack
        PUSH    MO                  ;    save <MO> on stack
        PUSH    mpr                 ;    save <mpr> on stack
        // calc active month: ---
        MOV     dividend, DD        ;    <dividend> = <DD>
        LDI     divisor, $07        ;    <divisor> = 7
        RCALL   div8u               ;    <result> = DIV(<dividend>, <divisor>)
        MOV     Www, result         ;    <Www> = <result>
        // add modulo to days: ---
        MOV     dividend, DD        ;    <dividend> = <DD>
        LDI     divisor, $07        ;    <divisor> = 7
        RCALL   MOD                 ;    <result> = MOD(<dividend>, <divisor>)
        MOV     DD, result          ;    <DD> = <result>
        DEC     MO                  ;    decrement <MO>
    GET_Www_WHILE01:                ;    while loop
        // calculate months til january: ---

        RCALL   DT_Www_MM           ;   DT_Www_MM(<DD>)

        MOV     dividend, DD        ;    <dividend> = <DD>
        LDI     divisor, $07        ;    <divisor> = 7
        RCALL   div8u               ;    <result> = DIV(<dividend>, <divisor>)
        ADD     Www, result         ;    <Www> = <result>
        // add modulo to days: ---
        MOV     dividend, DD        ;    <dividend> = <DD>
        LDI     divisor, $07        ;    <divisor> = 7
        RCALL   MOD                 ;    <result> = MOD(<dividend>, <divisor>)
        MOV     DD, result          ;    <DD> = <result>
        DEC     MO
        BRNE    GET_Www_WHILE01
        // weeknumber beginns with 1 not 0: ---
        INC     Www                 ;    <Www>++
        // stack loading: ---
        POP     mpr                 ;    load <mpr> from stack
        POP     MO                  ;    load <MO> from stack
        POP     dd                  ;    load <dd> from stack

        RET                         ;  RETURN <result>

;===============================================================================
; @name:             DT_Www_MM
; @description:
;   Handles the date-time Month calculation for week number calculation:
;
; @param *<DD>:
;  the day of the date
;------------------------------------------------------------------------------
DT_Www_MM:                          ;  [DT_Www_MM(*<DD>)] function
        // Stack saving: ---
        PUSH    mpr                 ;  save <mpr> on stack
        CPI     MO, $02             ;  if <MO> == 2
        BREQ    GET_Www_ELSEIF1     ;   GoTo: GET_Www_ELSEIF1 (february)
        // Handle if month has 30 or 31 Days
        CPI     MO, $07             ;      if <MO> < 7
        BRLO    GET_Www_ELSEIF4     ;       GoTo: GET_Www_ELSEIF4
        // Handle Aug-Dec: ---
        MOV     mpr, MO             ;        <mpr> = <MO>
        ASR     mpr                 ;        <mpr> = <mpr> / 2
        BRCS    GET_Www_30DAY       ;        if <carry-bit> = 0: GoTo: GET_Www_30DAY
        RJMP    GET_Www_31DAY       ;        else: GoTo: GET_Www_31DAY
    GET_Www_ELSEIF4:                ;      DT_MM_ELSEIF4
        // Handle Jan-Jul: ---
        MOV     mpr, MO             ;        <mpr> = <MO>
        ASR     mpr                 ;        <mpr> = <mpr> / 2
        BRCC    GET_Www_30DAY       ;        if <carry-bit> = 1: GoTo: GET_Www_30DAY
        RJMP    GET_Www_31DAY       ;        else: GoTo: GET_Www_31DAY
    GET_Www_30DAY:                  ;      DT_MM_30DAY
        // The Month has 30 Days: ---
        SUBI    DD, -30             ;        <DD> += 30
        RJMP    GET_Www_DAYEND      ;        GoTo: GET_Www_DAYEND
    GET_Www_31DAY:                  ;      DT_MM_31DAY
        // The Month has 31 Days: ---
        SUBI    DD, -31             ;        <DD> += 31
        RJMP    GET_Www_DAYEND      ;          GoTo: GET_Www_DAYEND
    GET_Www_DAYEND:                 ;      End Day calc
        RJMP    GET_Www_ENDIF1      ;  GoTo: GET_Www_ENDIF1
    GET_Www_ELSEIF1:                ;  GET_Www_ELSEIF1
        // Handle February: ---
        MOV     mpr, YY             ;    <mpr> = <YY>
        ASR     mpr                 ;    <mpr> = <mpr> / 2
        BRCS    GET_Www_ELSEIF2     ;    if <carry-bit> == 2: GoTo: GET_Www_ELSEIF2
        ASR     mpr                 ;    <mpr> = <mpr> / 2
        BRCS    GET_Www_ELSEIF2     ;    if <carry-bit> == 2: GoTo: GET_Www_ELSEIF2
        // Handle leap year: ---
        SUBI    DD, -29             ;      <DD> += 29
    GET_Www_ENDIF3:                 ;      GET_Www_ENDIF3
        RJMP    GET_Www_ENDIF2      ;    GoTo: GET_Www_ENDIF2
    GET_Www_ELSEIF2:                ;    GET_Www_ELSEIF2
        // Handle non leap year: ---
        SUBI    DD, -28             ;      <DD> += 29
    GET_Www_ENDIF2:                 ;    GET_Www_ENDIF2
    GET_Www_ENDIF1:                 ;  GET_Www_ENDIF1
        // Stack loading: ---
        POP     mpr                 ;  load <mpr> from stack
        RET                         ;  RETURN <void>


;===============================================================================
; @name:             DT_MM
; @description:
;   Handles the date-time Month calculation:
;
; @param <DD>:
;  the day of the date
;------------------------------------------------------------------------------
DT_MM:                              ;  [DT_MM(<DD>)] function
        // Stack saving: ---
        PUSH    mpr                 ;  save <mpr> on stack

        CPI     MO, $02             ;  if <MO> != 2
        BREQ    DT_MM_ELSEIF1       ;   GoTo: DT_MM_ENDIF1
        // Handle all months except February: ---
        CPI     DD, $1D             ;    if <DD> < 29:
        BRLO    DT_MM_ENDIF1        ;     GoTo: DT_MM_ENDIF1
        // Handle if month has 30 or 31 Days
        CPI     MO, $07             ;      if <MO> < 7
        BRLO    DT_MM_ELSEIF4       ;       GoTo: DT_MM_ELSEIF4
        // Handle Aug-Dec: ---
        MOV     mpr, MO             ;        <mpr> = <MO>
        ASR     mpr                 ;        <mpr> = <mpr> / 2
        BRCS    DT_MM_30DAY         ;        if <carry-bit> = 0: GoTo: DT_MM_30DAY
        RJMP    DT_MM_31DAY         ;        else: GoTo: DT_MM_31DAY
    DT_MM_ELSEIF4:                  ;      DT_MM_ELSEIF4
        // Handle Jan-Jul: ---
        MOV     mpr, MO             ;        <mpr> = <MO>
        ASR     mpr                 ;        <mpr> = <mpr> / 2
        BRCC    DT_MM_30DAY         ;        if <carry-bit> = 1: GoTo: DT_MM_30DAY
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



