;===============================================================================
;- @program:            display-driver       
;- -----------------------------------------------------------------------------
;- @filename:            Display.asm
;- @version:             1.0.0
;- @autor:               Benj Fassbind
;-
;- @purpose:             uP-Schulung
;-
;- @description:
;-  
;-  The LCD driver "speaks" with the LCD interface and puts content on the
;-  LCD screen. For this purpose various functions are implemented in 
;-  AVR-Assembly
;-                   
;- Copyright (c) 2014 Benj Fassbind

;--- uCONTROLLER (ATMega2560) ---
.include "m2560def.inc"

;--- INTERRUPT-ADDRESS-VECTORS ---
; -> Use 'nop' because interrupt-addresses are 16 bit,
;    even though its a 8 bit MCU
        RJMP   reset            ; Ext-Pin, Power-on, Brown-out,Watchdog Reset
        NOP                     ;  0x0000
        RETI                    ; External Interrupt Request 0
        NOP                     ;  0x0002
        RETI                    ; External Interrupt Request 1
        NOP                     ;  0x0004
        RETI                    ; External Interrupt Request 2
        NOP                     ;  0x0006
        RETI                    ; External Interrupt Request 3
        NOP                     ;  0x0008
        RETI                    ; External Interrupt Request 4
        NOP                     ;  0x000A
        RETI                    ; External Interrupt Request 5
        NOP                     ;  0x000C
        RETI                    ; External Interrupt Request 6
        NOP                     ;  0x000E
        RETI                    ; External Interrupt Request 7
        NOP                     ;  0x0010
        RETI                    ; Pin Change Interrupt Request 0
        NOP                     ;  0x0012
        RETI                    ; Pin Change Interrupt Request 1
        NOP                     ;  0x0014
        RETI                    ; Pin Change Interrupt Request 2
        NOP                     ;  0x0016
        RETI                    ; Watchdog Time-out Interrupt
        NOP                     ;  0x0018
        RETI                    ; Timer/Counter2 Compare Match A
        NOP                     ;  0x001A
        RETI                    ; Timer/Counter2 Compare Match B
        NOP                     ;  0x001C
        RETI                    ; Timer/Counter2 Overflow
        NOP                     ;  0x001E
        RETI                    ; Timer/Counter1 Capture Event
        NOP                     ;  0x0020
        RETI                    ; Timer/Counter1 Compare Match A
        NOP                     ;  0x0022
        RETI                    ; Timer/Counter1 Compare Match B
        NOP                     ;  0x0024
        RETI                    ; Timer/Counter1 Compare Match C
        NOP                     ;  0x0026
        RETI                    ; Timer/Counter1 Overflow
        NOP                     ;  0x0028
        RETI                    ; Timer/Counter0 Compare Match A
        NOP                     ;  0x002A
        RETI                    ; Timer/Counter0 Compare Match B
        NOP                     ;  0x002C
        RETI                    ; Timer/Counter0 Overflow
        NOP                     ;  0x002E
        RETI                    ; SPI Serial Transfer Complete
        NOP                     ;  0x0030
        RETI                    ; USART0 Rx Complete
        NOP                     ;  0x0032
        RETI                    ; USART0 Data Register Empty
        NOP                     ;  0x0034
        RETI                    ; USART0 Tx Complete
        NOP                     ;  0x0036
        RETI                    ; Analog Comparator
        NOP                     ;  0x0038
        RETI                    ; ADC Conversion Complete
        NOP                     ;  0x003A
        RETI                    ; EEPROM Ready
        NOP                     ;  0x003C
        RETI                    ; Timer/Counter3 Capture Event
        NOP                     ;  0x003E
        RETI                    ; Timer/Counter3 Compare Match A
        NOP                     ;  0x0040
        RETI                    ; Timer/Counter3 Compare Match B
        NOP                     ;  0x0042
        RETI                    ; Timer/Counter3 Compare Match C
        NOP                     ;  0x0044
        RETI                    ; Timer/Counter3 Overflow
        NOP                     ;  0x0046
        RETI                    ; USART1 Rx Complete
        NOP                     ;  0x0048
        RETI                    ; USART1 Data Register Empty
        NOP                     ;  0x004A
        RETI                    ; USART1 Tx Complete
        NOP                     ;  0x004C
        RETI                    ; 2-wire Serial Interface
        NOP                     ;  0x004E
        RETI                    ; Store Program Memory Ready
        NOP                     ;  0x0050
        RETI                    ; Store Program Memory Ready
        NOP                     ;  0x0052
        RETI                    ; Timer/Counter4 Capture Event
        NOP                     ;  0x0054
        RETI                    ; Timer/Counter4 Compare Match A
        NOP                     ;  0x0056
        RETI                    ; Timer/Counter4 Compare Match B
        NOP                     ;  0x0056
        RETI                    ; Timer/Counter4 Compare Match C
        NOP                     ;  0x0058
        RETI                    ; Timer/Counter4 Overflow
        NOP                     ;  0x005A
        RETI                    ; Timer/Counter5 Capture Event
        NOP                     ;  0x005C
        RETI                    ; Timer/Counter5 Compare Match A
        NOP                     ;  0x005E
        RETI                    ; Timer/Counter5 Compare Match B
        NOP                     ;  0x0060
        RETI                    ; Timer/Counter5 Compare Match C
        NOP                     ;  0x0062
        RETI                    ; Timer/Counter5 Overflow
        NOP                     ;  0x0064
        RETI                    ; USART2 Rx Complete
        NOP                     ;  0x0066
        RETI                    ; USART2 Data Register Empty
        NOP                     ;  0x0068
        RETI                    ; USART2 Tx Complete
        NOP                     ;  0x006A
        RETI                    ; USART3 Rx Complete
        NOP                     ;  0x006C
        RETI                    ; USART3 Data Register Empty
        NOP                     ;  0x006E
        RETI                    ; USART3 Tx Complete
        NOP                     ;  0x0070

;--- Include-Files ---
.include "..\..\..\lib\delay.inc"



;--- constants ---
.equ     LED          = PORTB         ; Output for LED
.equ     LED_D        = DDRB          ; Data direction Port for LED

.equ     SWITCH       = PIND          ; Input for SWITCH
.equ     SWITCH_D     = DDRD          ; Data direction Port for SWITCH

.equ     LCD          = PORTC         ; LCD output on Port C
.equ     LCD_D        = DDRC          ; Data direction Port for LCD

;--- variables ---
.def      mpr         = R16           ; multipurpose register

;--- delay variables ---
.def      ms          = R17           ; milli seconds register

;--- lcd variables ---
.def      RAM_ADDR    = R18           ; ram (cursor) pointer on lcd

/* CONTROL_MEM: ---
 The control memory is used for the Display ON/OFF Control,
 because this command has to set both the LCD and the cursor
 on or off. But for this driver we want seperate functions
 for each LCD and cursor on/off.

 'bit-0' is used to store the LCD status (1 = on; 0 = off)
 'bit-1' is used to store the cursor status (1 = on; 0 = off)

 Everything else will be ignored. Clear this register on reset. */
.def      CONTROL_MEM = R19           ; control memory (lcd and cursor are on/off)       




;------------------------------------------------------------------------------
; Main program
;------------------------------------------------------------------------------

;--- Initialisation ---
Reset:    SER         mpr                       ; Output = LED
          OUT         LED_D, mpr

          OUT         LCD_D, mpr                ; Output = LCD

          CLR         mpr                       ; Input = Switch-values
          OUT         SWITCH_D, mpr

          LDI         mpr, LOW(RAMEND)          ; Initialise stack
          OUT         SPL,mpr
          LDI         mpr, HIGH(RAMEND)
          OUT         SPH,mpr

          CLR         CONTROL_MEM               ; clear the control memory


;--- Main program: ---     
Main:                                           ; main function
          
          
          
          RJMP      Main                        ; endless loop

;------------------------------------------------------------------------------
; Subroutines
;------------------------------------------------------------------------------
;==============================================================================
; @name:    LCD_INI
; @description:
;  Initialises the Display. Sets up the communication from the Display to the
;  microcontroller.
;
;------------------------------------------------------------------------------
LCD_INI:                                        ; display initialisation
        
         PUSH       mpr                         ;  save mpr to stack

      /* Wait more than 30ms after 
         Vdd rises to 4.5V.

         FUNCTION SET: ---

         Ennable 4-bit mode with MPU.
         The LCD is set to 2-line mode
         with 5x8 dots characters.
         
         The three 0x03 is required because
         we don't know in which state the 
         controll is when the lcd is in 
         8-bit mode it stays there until you
         switch to 4-bit mode:

         state: 
         -------
         8-bit
         4-bit HB
         4-bit LB
         4-bit LO8 */

         // Be shure to turn on 8-bit mode.
         LDI        mpr, 0x03                   ;  'function set' 8-bit mode

         RCALL      W100MS                      ;  wait for more than 30ms
         OUT        LCD, mpr                    ;  send 'function set' 8-bit mode

         RCALL      W10MS                       ;  wait at least 4.1ms
         OUT        LCD, mpr                    ;  send 'function set' 8-bit mode

         RCALL      W100US                      ;  wait at least 100us
         OUT        LCD, mpr                    ;  send 'function set' 8-bit mode

         // 4-bit mode with MPU
         LDI        mpr, 0x02                   ;  'function set' instruction
         OUT        LCD, mpr                    ;  send 'function set' HN

         // 2-line mode and 5x8 dots char
         LDI        mpr, 0x0C                   ;  'function set' instruction
         OUT        LCD, mpr                    ;  send 'function set' LN

         RCALL      LCD_ON                      ;  turn the LCD on

         RCALL      W100US                      ;  wait for more than 39ns
         RCALL      LCD_CLR                     ;  clear the display
         RCALL      W10MS                       ;  wait for more than 1.53ms

      /* Entry mode set means that, 
         when writing the cursor moves to the
         right */

         POP        mpr                         ;  load mpr from stack

         RET                                    ; return from function



;==============================================================================
; @name:    LCD_ON
; @description:
;  Turns the LCD-Display on.
;
;------------------------------------------------------------------------------
LCD_ON:                                         ; turn display on
        PUSH       mpr                          ;  save mpr to stack

        RCALL      W100US                       ;  wait for more than 39ns
        LDI        mpr, 0x00                    ;  'display on/of' HN = 0x00        
        OUT        LCD, mpr                     ;  send 'display on/of' HN = 0x00
        
        // control if curser is on or off
        SBRS       CONTROL_MEM, 1               ;  curser status in control memory
        RJMP       LCD_ON_ELSEIF01

        // curser has to be turned on
        LDI        mpr, 0x0E                    ;  turn display and cursor on
        OUT        LCD, mpr                     ;  send 'display on/off control'
        RJMP       LCD_ON_ENDIF01
    LCD_ON_ELSEIF01:
        
        // curser has to be turned off
        LDI        mpr, 0x0C                    ;  turn display on
        OUT        LCD, mpr                     ;  send 'display on/off control'
    LCD_ON_ENDIF01:   

        POP         mpr                         ;  load mpr from stack

        RET                                     ; return from function

;==============================================================================
; @name:    CUR_ON
; @description:
;  Turns the Cursor on.
;
;------------------------------------------------------------------------------
CUR_ON:                                         ; turn cursor on
        
        

        RET                                     ; return from function

;==============================================================================
; @name:    LCD_OFF
; @description:
;  Turns the LCD-Display off.
;
;------------------------------------------------------------------------------
LCD_OFF:                                        ; turn display off

        

        RET                                     ; return from function

;==============================================================================
; @name:    CUR_OFF
; @description:
;  Turns the cursor off.
;
;------------------------------------------------------------------------------
CUR_OFF:                                        ; turn cursor off
    
        

        RET                                     ; return from function

;==============================================================================
; @name:    LCD_CLR
; @description:
;  Clears the LCD-Display content.
;
;------------------------------------------------------------------------------
LCD_CLR:                                        ; clears the display

        

        RET                                     ; return from function

;==============================================================================
; @name:    LCD_RAM
; @description:
;  Sets the curser to the given RAM address. The RAM address defines where
;  on the display the content is put.
;
; @param <RAM_ADR>
;  The address to set the curser to.
;
;------------------------------------------------------------------------------
LCD_RAM:                                        ; sets the ram address

        

        RET                                     ; return from function

;==============================================================================
; @name:    LCD_CHR
; @description:
;  Writes a ascii character to the display.
;
; @param <CHAR>
;  The output char
;
;------------------------------------------------------------------------------
LCD_CHR:                                        ; puts a char to the display

        

        RET                                     ; return from function

;==============================================================================
; @name:    LCD_STR
; @description:
;  Writes a string to the display from the beginn address to the $00 char.
;
; @param *<STR>
;  The output string address
;
;------------------------------------------------------------------------------
LCD_STR:                                        ; puts a string to the display

        

        RET                                     ; return from function


;==============================================================================
; @name:    LCD_HEX
; @description:
;  Writes a hex number to the display.
;
; @param <HEX>
;  The output hex value
;
;------------------------------------------------------------------------------
LCD_HEX:                                        ; outputs a hex value

        

        RET                                     ; return from function

;==============================================================================
; @name:    LCD_INT16
; @description:
;  Writes a int16 number to the display.
;
; @param <INT16>
;  The output int16 value
;
;------------------------------------------------------------------------------
LCD_INT16:                                      ; outputs a int16 value

        

        RET                                     ; return from function



