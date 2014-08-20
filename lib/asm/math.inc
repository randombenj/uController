;===============================================================================
; Programm:                 math
;
; Dateinname:               math.inc
; Version:                  0.1.0
; Autor:                    Benj Fassbind
;
; Verwendungszweck:         uP-Schulung
;
; Beschreibung:
;  
;  Various math operations.
;   - DIV
;   - MOD
;
; Entwicklungsablauf:
; Ver: Datum:    Autor:   Entwicklungsschritt:                         Zeit:
; 0.1.0  21.1.14  FAB    Ganzes Programm erstellt                        Min.
;
;                                        Totalzeit:     Min.
;
; Copyright: Benj Fassbind, Sonneggstrasse 13, 6410 Goldau (2013)
;------------------------------------------------------------------------------

;===============================================================================
; Funktion:             DIV
; Datum:                21.2.2014
; Version:              0.1.0
;
; Beschrieb:
;   8/8 bit division mit 8 bit return.
;
; Register:
;  mpr      8bit
;  dividend 8bit
;  divisor  8bit
;  result   8bit
;------------------------------------------------------------------------------
DIV:
        // stack speichern: ---
        PUSH    dividend            ;   <dividend> auf stack speichern
        PUSH    divisor             ;   <dividend> divisor auf stack speichern
        PUSH    mpr                 ;   <mpr> auf stack speichern

        CLR     result              ;   <result> = $00
        CLR     mpr                 ;   <mpr> = $00

        TST     divisor             ;   if <divisor> == 0
        BREQ    DevByZero           ;     "devide by zero"

    While:                          ;   While 
        TST     dividend            ;    <dividend> == 0
        BREQ    EndWhile            ;    Goto: EndWhile

        CLC                         ;     Clear <c-bit>
        LSL     result              ;     <result> = <result> << 1

        LSL     dividend            ;     <dividend> = <dividend> << 1
        ROL     mpr                 ;     Rotate <mpr> Right
        
        CP      mpr, divisor        ;     <mpr> >= <divisor>
        BRLO    EndSub              ;      Goto: EndSub

        INC     result              ;         <result> = <result> << 1
        SUB     mpr, divisor        ;         <mpr> = <mpr> - <divisor>
    EndSub:                         ;       EndSub
        RJMP    While               ;     Loop  
    EndWhile:                       ;   End While loop
  DevByZero:                        ;   Devide by zero

        // stack laden: ---
        POP     mpr                 ;   <mpr> von stack laden
        POP     divisor             ;   <dividend> von stack laden
        POP     dividend            ;   <dividend> von stack laden

        RET                         ;   RETURN: <result>

;***************************************************************************
;*
;* "div8u" - 8/8 Bit Unsigned Division
;*
;* This subroutine divides the two register variables "dividend" (dividend) and 
;* "divisor" (divisor). The result is placed in "result" and the remainder in
;* "remind".
;*  
;* Number of words	:14
;* Number of cycles	:97
;* Low registers used	:1 (remind)
;* High registers used  :3 (result/dividend,divisor,count)
;*
;***************************************************************************
                                    
;***** Subroutine Register Variables
                                    
/*.def	remind	=r15		;remainder
.def	result	=r16		;result
.def	dividend	=r16		;dividend
.def	divisor	=r17		;divisor
.def	count	=r18		;loop counter*/
                                    
;***** Code
                                    
div8u:	
        // stack speichern: ---
        PUSH    dividend            ;    <dividend> auf stack speichern
        PUSH    divisor             ;    <divisor> auf stack speichern
        PUSH    mpr                 ;    <mpr> auf stack speichern   
        PUSH    count               

        sub	    mpr,mpr	            ;clear remainder and carry
        ldi	    count,9	            ;init loop counter
    d8u_1:	
        rol	    dividend	        ;shift left dividend
        dec	    count		        ;decrement counter
        brne	d8u_2		        ;if done

        MOV     result, dividend    ;result is in dividend

        // stack laden: ---
        POP     count
        POP     mpr                 ;    <mpr> von stack laden
        POP     divisor             ;    <divisor> von stack laden
        POP     dividend            ;    <dividend> von stack laden

        ret			                ;    return
    d8u_2:	
        rol 	mpr		            ;shift dividend into remainder
        sub	    mpr,divisor	        ;remainder = remainder - divisor
        brcc	d8u_3		        ;if result negative
        add	    mpr,divisor	        ;    restore remainder
        clc			                ;    clear carry to be shifted into result
        rjmp	d8u_1		        ;else
    d8u_3:	
        sec			                ;    set carry to be shifted into result
        rjmp	d8u_1

;===============================================================================
; Funktion:             DIV
; Datum:                21.2.2014
; Version:              0.1.0
;
; Beschrieb:
;   8%8 bit modulo mit 8 bit return.
;
; Register:
;  mpr      8bit
;  dividend 8bit
;  divisor  8bit
;  result   8bit
;------------------------------------------------------------------------------
MOD:                                ;  [MOD(<dividend>, <divisor>)] function
        // stack speichern: ---
        PUSH    dividend            ;    <dividend> auf stack speichern
        PUSH    divisor             ;    <divisor> auf stack speichern
        PUSH    mpr                 ;    <mpr> auf stack speichern

        // modulo: ---
        RCALL   div8u               ;    <result> = DIV(<dividend>, <divisor>)
        MUL     result, divisor     ;    <R1:R0> = resultat * divisor
        SUB     dividend, R0        ;    <dividend> = <R0> - <dividend>

        CPI     dividend, $00       ;    if <dividend> > $00
        BRGE    MOD_ENDIF01         ;      GoTo: MOD_ENDIF01
        // wenn dividend negative make positive: ---
        NEG     dividend            ;      |<dividend>|
    MOD_ENDIF01:
        
        MOV     result, dividend    ;    <result> = <dividend>

        // stack laden: ---
        POP     mpr                 ;    <mpr> von stack laden
        POP     divisor             ;    <divisor> von stack laden
        POP     dividend            ;    <dividend> von stack laden

        RET                         ;  RETURN: <result>