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

.equ     LCD          = PORTA         ; LCD output on Port C
.equ     LCD_D        = DDRA          ; Data direction Port for LCD

.equ     ENABLE       = 0x20          ; ENABLE at port postion 5

;--- variables ---
.def      mpr         = R16           ; multipurpose register
.def      inst        = R20           ; instruction register

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
reset:    SER         mpr                       ; Output = LED
          OUT         LED_D, mpr

          OUT         LCD_D, mpr                ; Output = LCD

          CLR         mpr                       ; Input = Switch-values
          OUT         SWITCH_D, mpr

          LDI         mpr, LOW(RAMEND)          ; Initialise stack
          OUT         SPL,mpr
          LDI         mpr, HIGH(RAMEND)
          OUT         SPH,mpr

          CLR         CONTROL_MEM               ; clear the control memory
          CLR         inst                      ; clear the next instruction

          RCALL       LCD_INI                   ; initialise the lcd
          RCALL       CUR_ON                    ; turn cursor on

;--- Main program: ---     
main:                                           ; main function
          
          RJMP      main                        ; endless loop

;------------------------------------------------------------------------------
; Subroutines
;------------------------------------------------------------------------------
;==============================================================================
; @name:    LCD_INI
; @description:
;  Initialises the Display. Sets up the communication from the Display to the
;  microcontroller.
; 
;  INITIALISATION FLOWCHART:
;
;   -> delay 100ms (Vdd rises to 4.5V)
;
;   'reset' the lcd
;
;  'function set'
;   -> delay 100us
;
;  'display on/off control'
;   -> delay 100us
;
;  CALL: LCD_ON
;
;  'entry mode set'
;   -> delay 100us
;
;------------------------------------------------------------------------------
LCD_INI:                                        ; display initialisation
        
         PUSH       inst                        ;  save instruction to stack

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

      // Be shure to turn on 8-bit mode. (resets the LCD)
         LDI        inst, 0x03                  ;  'function set' 8-bit mode

         RCALL      W100MS                      ;  wait for more than 30ms
         RCALL      LCD_WRITE_INST              ;  send 'function set' 8-bit mode

         RCALL      W10MS                       ;  wait at least 4.1ms
         RCALL      LCD_WRITE_INST              ;  send 'function set' 8-bit mode

         RCALL      W1MS                        ;  wait at least 100us
         RCALL      LCD_WRITE_INST              ;  send 'function set' 8-bit mode
         
         RCALL      W10MS                       ;  wait at least 4.1ms
         LDI        inst, 0x02                  ;  'function set' instruction
         RCALL      LCD_WRITE_INST              ;  send 'function set' HN

         RCALL      W100US                      ;  wait for more than 40us
      // 4-bit mode with MPU 
         LDI        inst, 0x02                  ;  'function set' instruction
         RCALL      LCD_WRITE_INST              ;  send 'function set' HN
         
      // 2-line mode and 5x8 dots char
         LDI        inst, 0x08                  ;  'function set' instruction
         RCALL      LCD_WRITE_INST              ;  send 'function set' LN

         RCALL      W100US                      ;  wait for more than 39ms

         RCALL      LCD_ON                      ;  turn the LCD on

         RCALL      LCD_CLR                     ;  clear the display

      /* Entry mode set means that, 
         when writing the cursor moves to the
         right.
         
         We want to increment the cursor
         (move to the right when writing)
         and not shift the display.*/
         LDI        inst, 0x00                  ;  'entry mode set' HN
         RCALL      LCD_WRITE_INST              ;  send 'entry mode set' HN

      // increment cursor, don't shift
         LDI        inst, 0x06                  ;  'entry mode set' LN
         RCALL      LCD_WRITE_INST              ;  send 'entry mode set' LN

         RCALL      W1MS                        ;  wait for the command to finish

         POP        inst                        ;  load instrution from stack

         RET                                    ; return from function

;==============================================================================
; @name:    LCD_ENABLE
; @description:
;  Sends a instruction to the LCD
; @param {uint_8} inst
;  The instruction to sent to the LCD
;
;------------------------------------------------------------------------------
LCD_WRITE_INST:                                 ; writes data to the LCD

        PUSH        inst                        ;  save instruction to stack
        
     // TODO: handle registerselect

        SBI         LCD, 5                      ;  set 'ennable command'   

     /* ENABLE Rise/Fall Time 20ns
        + ENABLE hold time (min. 230ns) */ 
        NOP                                     ;  delays @8mhz for 125ns
        NOP                                     ;  delays @8mhz for 125ns
        
     /* While data is sent to the LCD the
        Enable sould be set */
        SBR        inst, ENABLE                 ;  set enable for next instruction
        
     /* Send data to the LCD and wait 
        at least 80ns for the LCD to read */
        OUT        LCD, inst                    ;  send instruction to LCD
        NOP                                     ;  delays @8mhz for 125ns
        NOP                                     ;  delays @8mhz for 125ns  


     /* When shure the cycle is over ->
        ennable for next cycle */
        CBI         LCD, 5                      ;  clear 'ennable command'
        
     /* Hold data for at least 10ns
        after enable falls to 0 */ 
        NOP                                     ;  delays @8mhz for 125ns
        NOP                                     ;  delays @8mhz for 125ns
        
     /* clear the data sent to the LCD */
        LDI         inst, 0x00                  ;  prepare 'clear'
        OUT         LCD, inst                   ;  clear content
                
        POP         inst                        ;  load instruction from stack

        RET                                     ; return from function


;==============================================================================
; @name:    LCD_ON
; @description:
;  Turns the LCD-Display on.
;
;------------------------------------------------------------------------------
LCD_ON:                                         ; turn display on
        PUSH       inst                         ;  save instruction to stack
        
        LDI        inst, 0x00                   ;  'display on/of' HN = 0x00
        RCALL      LCD_WRITE_INST               ;  write instruction
        
        LDI        inst, 0x0C                   ;  display on

     // handle cursor
        SBRC       CONTROL_MEM, 1               ;  if curser has to be turned on:
        SBR        inst, 2                      ;  turn curser on

     // save lcd state to control memory
        SBR        CONTROL_MEM, 1               ;  display state: on

        RCALL      LCD_WRITE_INST               ;  write instruction

        RCALL      W100US                       ;  wait for more than 39ns

        POP        inst                         ;  load mpr from stack
        RET                                     ; return from function

;==============================================================================
; @name:    CUR_ON
; @description:
;  Turns the Cursor on.
;
;------------------------------------------------------------------------------
CUR_ON:                                         ; turn cursor on
        PUSH       inst                         ;  save instruction to stack
        
        LDI        inst, 0x00                   ;  'display on/of' HN = 0x00      
        RCALL      LCD_WRITE_INST               ;  write instruction
        
        LDI        inst, 0x0A                   ;  cursor on

     // handle display
        SBRC       CONTROL_MEM, 0               ;  if display has to be turned on:
        SBR        inst, 4                      ;  turn display on

     // save cursor state to control memory
        SBR        CONTROL_MEM, 2               ;  cursor state: on
        
        RCALL      LCD_WRITE_INST               ;  write instruction

        RCALL      W100US                       ;  wait for more than 39ns

        POP        inst                         ;  load instruction from stack
        RET                                     ; return from function

;==============================================================================
; @name:    LCD_OFF
; @description:
;  Turns the LCD-Display off.
;
;------------------------------------------------------------------------------
LCD_OFF:                                        ; turn display off
        PUSH       inst                         ;  save instruction to stack

        LDI        inst, 0x00                   ;  'display on/of' HN = 0x00        
        RCALL      LCD_WRITE_INST               ;  send 'display on/of' HN = 0x00
        
        LDI        inst, 0x08                   ;  display off

     // handle cursor
        SBRC       CONTROL_MEM, 1               ;  if curser has to be turned on:
        SBR        inst, 2                      ;  turn curser on

     // save lcd state to control memory
        CBR        CONTROL_MEM, 1               ;  display state: off

        RCALL      LCD_WRITE_INST               ;  send 'display on/off control'

        RCALL      W100US                       ;  wait for more than 39ns

        POP        inst                         ;  load instruction from stack
        RET                                     ; return from function

;==============================================================================
; @name:    CUR_OFF
; @description:
;  Turns the cursor off.
;
;------------------------------------------------------------------------------
CUR_OFF:                                        ; turn cursor off
        PUSH       inst                         ;  save inst to stack

        LDI        inst, 0x00                   ;  'display on/of' HN = 0x00        
        RCALL      LCD_WRITE_INST               ;  send 'display on/of' HN = 0x00
        
        LDI        inst, 0x08                   ;  cursor on

     // handle display
        SBRC       CONTROL_MEM, 0               ;  if display has to be turned on:
        SBR        inst, 4                      ;  turn display on

     // save cursor state to control memory
        CBR        CONTROL_MEM, 2               ;  cursor state: off

        RCALL      LCD_WRITE_INST               ;  send 'display on/off control'

        RCALL      W100US                       ;  wait for more than 39ns

        POP        inst                         ;  load inst from stack
        RET                                     ; return from function

;==============================================================================
; @name:    LCD_CLR
; @description:
;  Clears the LCD-Display content. DDRAM address will be set to 0x00 on
;  the display.
;  Brings the cursor to the left edge on the first line of the display.
;
;------------------------------------------------------------------------------
LCD_CLR:                                        ; clears the display
        PUSH       inst                         ;  save instruction to stack
        
        LDI        inst, 0x00                   ;  'clear display' HN
        RCALL      LCD_WRITE_INST               ;  write instruction
        
        LDI        inst, 0x01                   ;  'clear display' LN command
        RCALL      LCD_WRITE_INST               ;  write instruction

        RCALL      W10MS                        ;  wait for more than 1.53ms

        POP        inst                         ;  load instruction from stack
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

;==============================================================================
; DATA SEGMENT
;------------------------------------------------------------------------------
        .db        "Hallo Welt",0

