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
;-  AVR-Assembly. The Interface with the MPU is 4 bit long.
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
.equ     REG_SELECT   = 0x10          ; REGISTERSELECT at port position 4

;--- lcd instructions ---

;------------------------------------------------------------
; FUNCTION SET:
;------------------------------------------------------------
;  RS | R/W | DB7 | DB6 | DB5 | DB4 | DB3 | DB2 | DB1 | DB0 |
;------------------------------------------------------------
;  0  |  0  |  0  |  0  |  1  |  DL |  N  |  F  |  -  |  -  |
;------------------------------------------------------------
; DL: interface data length control bit (4 bit mode)
; N:  line number (2 line)
; F:  font type (5x8 bit)
.equ    FUNCTION_SET  = 0x28

;------------------------------------------------------------
; ENTRY MODE SET:
;------------------------------------------------------------
;  RS | R/W | DB7 | DB6 | DB5 | DB4 | DB3 | DB2 | DB1 | DB0 |
;------------------------------------------------------------
;  0  |  0  |  1  |  0  |  0  |  0  |  0  |  1  | I/D |  SH |
;------------------------------------------------------------
; I/D: increment / decrement of DDRAM address (move to right)
; SH:  shift of entire display (no shift)
;
; Entry mode set means that, 
; when writing the cursor moves to the
; right.
;         
; We want to increment the cursor
; (move to the right when writing)
; and not shift the display.
.equ    ENTRYMODE_SET = 0x06  

;------------------------------------------------------------
; LCD ON / CURSOR ON:
;------------------------------------------------------------
;  RS | R/W | DB7 | DB6 | DB5 | DB4 | DB3 | DB2 | DB1 | DB0 |
;------------------------------------------------------------
;  0  |  0  |  0  |  0  |  0  |  0  |  1  |  D  |  C  |  B  |
;------------------------------------------------------------
; turn LCD/Cursor/blink On or Off (raw command)
; D: display on/off
; C: cursor on/off
; B: cursor blink on/off (off)
.equ    LCD_CTRL_RAW  = 0x08  // raw command (all off)
.equ    LCD_CTRL_CUR  = 0x0A  // raw command (cursor on)
.equ    LCD_CTRL_LCD  = 0x0C  // raw command (lcd on)

;------------------------------------------------------------
; CLEAR THE LCD:
;------------------------------------------------------------
;  RS | R/W | DB7 | DB6 | DB5 | DB4 | DB3 | DB2 | DB1 | DB0 |
;------------------------------------------------------------
;  0  |  0  |  0  |  0  |  0  |  0  |  0  |  0  |  0  |  1  |
;------------------------------------------------------------
; writes 0x20 ' ' (space) to all DDRAM addresses and return
; cursor home (address: 0x00)
.equ    CLEAR_LCD  = 0x01  

;------------------------------------------------------------
; SET DDRAM ADDRESS:
;------------------------------------------------------------
;  RS | R/W | DB7 | DB6 | DB5 | DB4 | DB3 | DB2 | DB1 | DB0 |
;------------------------------------------------------------
;  0  |  0  |  1  | AC6 | AC5 | AC4 | AC3 | AC2 | AC1 | AC0 |
;------------------------------------------------------------
; set display data ram address (raw command)
.equ    SET_DDRAM     = 0x80 

;--- variables ---
.def      mpr         = R16           ; multipurpose register
.def      inst        = R20           ; instruction register
.def      hex         = R21           ; register for hex number

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
       // string output (Z register = str address)
          LDI       ZH, HIGH(string << 1)       ;  load string refference (high byte)
          LDI       ZL, LOW(string << 1)        ;  load string refference (low byte)

          RCALL     LCD_STR                     ;  write string to lcd

          LDI       XL, low(0x16)

          RCALL     LCD_INT16

    endl:
          RJMP      endl                        ; endless loop

;------------------------------------------------------------------------------
; Subroutines
;------------------------------------------------------------------------------

;==============================================================================
; @name:    LCD_WRITE
; @description:
;  Sends a instruction or data to the LCD
; @param {uint_8} inst
;  The instruction/data to sent to the LCD
;
;------------------------------------------------------------------------------
LCD_WRITE:                                      ; writes to the LCD (4 bit mode)
       
        PUSH        inst                        ;  save instruction to stack
        PUSH        mpr                         ;  save mpr to stack

        MOV         mpr, inst                   ;  save instruction value
     // HIGH NIBBLE
        SWAP        inst                        ;  first send the high nibble
        ANDI        inst, 0x0F                  ;  send only high nibble
        RCALL       LCD_WRITE4BIT               ;  write to the lcd
       
     // LOW NIBBLE
        MOV         inst, mpr                   ;  load instruction value
        ANDI        inst, 0x0F                  ;  send only low nibble
        RCALL       LCD_WRITE4BIT               ;  write to the lcd

        POP         mpr                         ;  load mpr from stack
        POP         inst                        ;  load instruction from stack

        RET                                     ; return from function

;==============================================================================
; @name:    LCD_WRITE_DATA
; @description:
;  Sends data to the LCD
; @param {uint_8} inst
;  The data to sent to the LCD
;
;------------------------------------------------------------------------------
LCD_WRITE_DATA:                                 ; writes data to the LCD

        PUSH        inst                        ;  save instruction to stack
        PUSH        mpr                         ;  save mpr to stack
        
     /* When putting data to the LCD in 4 bit mode
        first send the high followed 
        by the low nibble */

        MOV         mpr, inst                   ;  save data
     // HIGH NIBBLE
        SWAP        inst                        ;  first send the high nibble
        ANDI        inst, 0x0F                  ;  send only high nibble
        RCALL       LCD_WRITE4BIT_DATA          ;  write to the lcd

     // LOW NIBBLE
        MOV         inst, mpr                   ;  load data
        ANDI        inst, 0x0F                  ;  send only low nibble
        RCALL       LCD_WRITE4BIT_DATA          ;  write to the lcd

        RCALL       W100US                      ;  wait for the LCD to process the data
        
        POP         mpr                         ;  load mpr from stack        
        POP         inst                        ;  load instruction from stack

        RET                                     ; return from function

;==============================================================================
; @name:    LCD_WRITE4BIT
; @description:
;  Direct instruction/data LCD 4Bit Interface
; @param {uint_8} inst
;  The 4bit instruction/data to sent to the LCD
;
;------------------------------------------------------------------------------
LCD_WRITE4BIT:                                  ; writes to the LCD (4 bit mode)

        PUSH        inst                        ;  save instruction to stack

        SBI         LCD, 5                      ;  set 'ennable command'   

     /* ENABLE Rise/Fall Time 20ns
        + ENABLE hold time (min. 230ns) */ 
        NOP                                     ;  delays @8mhz for 125ns
        NOP                                     ;  delays @8mhz for 125ns
        
     /* While data is sent to the LCD the
        Enable sould be set */
        SBR        inst, ENABLE                 ;  set enable for next instruction
        
     /* If Register select is set set it
        while data is sent to the LCD */
        SBIC       LCD, 4                       ;  if data is sent to LCD
        SBR        inst, REG_SELECT             ;   set register select for next instruction

     /* Send data to the LCD and wait 
        at least 80ns for the LCD to read */
        OUT        LCD, inst                    ;  send instruction to LCD
        NOP                                     ;  delays @8mhz for 125ns
        NOP                                     ;  delays @8mhz for 125ns  

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
; @name:    LCD_WRITE4BIT_DATA
; @description:
;  Direct 4bit data interface with the LCD
; @param {uint_8} inst
;  The 4bit data to sent to the LCD
;
;------------------------------------------------------------------------------
LCD_WRITE4BIT_DATA:                             ; writes data to the LCD (4 bit interface)

        PUSH        inst                        ;  save instruction to stack
        
        SBI         LCD, 4                      ;  send 'register select
     /* Registerselect setup time 40ns */
        NOP                                     ;  delays @8mhz for 125ns
        NOP                                     ;  delays @8mhz for 125ns  

        RCALL       LCD_WRITE4BIT               ;  write data to lcd
        RCALL       W100US                      ;  wait for the LCD to process the data
                
        POP         inst                        ;  load instruction from stack

        RET                                     ; return from function

;==============================================================================
; @name:    LCD_INI
; @description:
;  Initialises the Display. Sets up the communication from the Display to the
;  microcontroller. (Only for 4 bit mode)
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
         RCALL      LCD_WRITE4BIT               ;  send 'function set' 8-bit mode

         RCALL      W10MS                       ;  wait at least 4.1ms
         RCALL      LCD_WRITE4BIT               ;  send 'function set' 8-bit mode

         RCALL      W1MS                        ;  wait at least 100us
         RCALL      LCD_WRITE4BIT               ;  send 'function set' 8-bit mode
         
         RCALL      W10MS                       ;  wait at least 4.1ms
         LDI        inst, 0x02                  ;  'function set' instruction
         RCALL      LCD_WRITE4BIT               ;  send 'function set' HN

         RCALL      W100US                      ;  wait for more than 40us

     /*  4-bit interface with MPU   
         2-line mode and 5x8 dots char */
         LDI        inst, FUNCTION_SET          ;  write 'function set' command
         RCALL      LCD_WRITE                   ;  send 'function set' command

         RCALL      W100US                      ;  wait for more than 39ms

         RCALL      LCD_ON                      ;  turn the LCD on

         RCALL      LCD_CLR                     ;  clear the display

      // increment cursor, don't shift
         LDI        inst, ENTRYMODE_SET         ;  'entry mode set'
         RCALL      LCD_WRITE                   ;  send 'entry mode set'

         RCALL      W1MS                        ;  wait for the command to finish

         POP        inst                        ;  load instrution from stack

         RET                                    ; return from function

;==============================================================================
; @name:    LCD_ON
; @description:
;  Turns the LCD-Display on.
;
;------------------------------------------------------------------------------
LCD_ON:                                         ; turn display on
        PUSH       inst                         ;  save instruction to stack

        LDI        inst, LCD_CTRL_LCD           ;  display on

     // handle cursor
        SBRC       CONTROL_MEM, 1               ;  if curser has to be turned on:
        SBR        inst, 2                      ;  turn curser on

     // save lcd state to control memory
        SBR        CONTROL_MEM, 1               ;  display state: on

        RCALL      LCD_WRITE                    ;  write instruction

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
        
        LDI        inst, LCD_CTRL_CUR           ;  cursor on

     // handle display
        SBRC       CONTROL_MEM, 0               ;  if display has to be turned on:
        SBR        inst, 4                      ;  turn display on

     // save cursor state to control memory
        SBR        CONTROL_MEM, 2               ;  cursor state: on
        
        RCALL      LCD_WRITE                    ;  write instruction

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
        
        LDI        inst, LCD_CTRL_RAW           ;  display off

     // handle cursor
        SBRC       CONTROL_MEM, 1               ;  if curser has to be turned on:
        SBR        inst, 2                      ;  turn curser on

     // save lcd state to control memory
        CBR        CONTROL_MEM, 1               ;  display state: off

        RCALL      LCD_WRITE                    ;  send 'display on/off control'

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
        
        LDI        inst, LCD_CTRL_RAW           ;  display off

     // handle display
        SBRC       CONTROL_MEM, 0               ;  if display has to be turned on:
        SBR        inst, 4                      ;  turn display on

     // save cursor state to control memory
        CBR        CONTROL_MEM, 2               ;  cursor state: off

        RCALL      LCD_WRITE                    ;  send 'display on/off control'

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
        
        LDI        inst, CLEAR_LCD              ;  'clear display' command
        RCALL      LCD_WRITE                    ;  write instruction

        RCALL      W10MS                        ;  wait for more than 1.53ms

        POP        inst                         ;  load instruction from stack
        RET                                     ; return from function

;==============================================================================
; @name:    LCD_RAM
; @description:
;  Sets the curser to the given RAM address. The RAM address defines where
;  on the display the content is put.
;
;  -> first line:   0x00 - 0x27
;  -> second line:  0x40 - 0x67
;
; @param {uint_8) RAM_ADDR
;  The address to set the curser to.
;
;------------------------------------------------------------------------------
LCD_RAM:                                        ; sets the ram address
        PUSH        RAM_ADDR                    ;  save ram address to stack
        PUSH        inst                        ;  save instruction to stack
        
        SBR         RAM_ADDR, SET_DDRAM         ;  set ddram command
        MOV         inst, RAM_ADDR              ;  set instruction
        RCALL       LCD_WRITE                   ;  write to the lcd
        
        RCALL       W1MS                        ;  wait for the lcd to process

        POP         inst                        ;  load instruction from stack
        POP         RAM_ADDR                    ;  load ram address from stack
        RET                                     ; return from function

;==============================================================================
; @name:    LCD_CHR
; @description:
;  Writes a ascii character to the display.
;
; @param {char} mpr
;  The output char
;
;------------------------------------------------------------------------------
LCD_CHR:                                        ; puts a char to the display
        PUSH        inst                        ;  save instruction to stack
        PUSH        mpr                         ;  save mpr to stack
        
        MOV         inst, mpr                   ;  move the character to the instruction register
        RCALL       LCD_WRITE_DATA              ;  send data to the lcd

        POP         mpr                         ;  load mpr from stack
        POP         inst                        ;  load instruction from stack

        RET                                     ; return from function

;==============================================================================
; @name:    LCD_STR
; @description:
;  Writes a string to the display from the beginn address to the $00 char.
;
; @param {char[]} X
;  The output string address (X register)
;
;------------------------------------------------------------------------------
LCD_STR:                                        ; puts a string to the display
        PUSH        mpr                         ;  save mpr to stack
     /* load the string refference and put
        the character to the screen */
        LPM         mpr, Z+                     ;  load first character to mpr
    NEXT_CHAR:
        RCALL       LCD_CHR                     ;   write character to lcd
        LPM         mpr, Z+                     ;   load next character to mpr
        TST         mpr                         ;   when string is not finished: $00 ('\0')
        BRNE        NEXT_CHAR                   ;  process next character      

        POP         mpr                         ;  load mpr from stack
        RET                                     ; return from function


;==============================================================================
; @name:    LCD_HEX
; @description:
;  Writes a hex number to the display.
;
; @param {uint_8} hex
;  The output hex value
;
;------------------------------------------------------------------------------
LCD_HEX:                                        ; outputs a hex value
        PUSH        hex                         ;  save hex to stack
        PUSH        mpr                         ;  save number to stack
        // TODO: wenn hex + x dann ascii
     // Put hex prefix '0x' on screen
        LDI         mpr, '0'                    
        RCALL       LCD_CHR

        LDI         mpr, 'x'
        RCALL       LCD_CHR
        
     // HIGH NIBBLE (of hex number)
        SWAP        hex                         ;  first convert the high nibble
        MOV         mpr, hex                    ;  move the character to the mpr
        ANDI        mpr, 0x0F                   ;  send only high nibble
        RCALL       TO_CHAR                     ;  convert to hex character
        RCALL       LCD_CHR                     ;  write character to lcd

     // LOW NIBBLE  (of hex number)
        SWAP        hex                         ;  second convert the low nibble
        MOV         mpr, hex                    ;  move the character to the mpr
        ANDI        mpr, 0x0F                   ;  send only low nibble
        RCALL       TO_CHAR                     ;  convert to hex character
        RCALL       LCD_CHR                     ;  write character to lcd
         
        POP         mpr                         ;  load number from stack
        POP         hex                         ;  load hex from stack
        RET                                     ; return from function

;==============================================================================
; @name:    LCD_INT16
; @description:
;  Writes a int16 number to the display.
;
; @param {int_16} X
;  The output int16 value (X register)
;
;------------------------------------------------------------------------------
LCD_INT16:                                      ; outputs a int16 value
        PUSH     mpr                            ;  save mpr to stack
     // save 16 bit nuber to stack
        PUSH     XL
        PUSH     XH
 
     /* when the number is negative print a minus ('-')
        and print the positive number (twos complement) */
        SBRS    XH, 7                           ;  if nuber is positive
        RJMP    LCD_INT16_ENDIF01               ;  skip signed
     // number is signed
        COM     XL                              ;  invert low byte (1's complement)
        COM     XH                              ;  invert high byte (1's complement)
     // add 0x0001 to X register
        SUBI    XL, 0xFF                        
        SBCI    XH, 0xFF
     // print '-' to lcd
        LDI     mpr, '-'
        RCALL   LCD_CHR                         ;  print '-'
    LCD_INT16_ENDIF01:

     // ten thousend
        LDI      mpr, '0'-1
LCD_NUMBER1:
        INC      mpr
        SUBI     XL, low(10000)
        SBCI     XH, high(10000)
        BRCC     LCD_NUMBER1
        SUBI     XL, low(-10000)
        SBCI     XH, high(-10000)
     // don't print leading zeros
        CPI      mpr, '0'
        BREQ     LCD_NUMBER1_END
        RCALL    LCD_CHR
        SET
LCD_NUMBER1_END:

     // thousend
        LDI      mpr, '0'-1
LCD_NUMBER2:
        INC      mpr
        SUBI     XL, low(1000)
        SBCI     XH, high(1000)
        BRCC     LCD_NUMBER2
        SUBI     XL, low(-1000)
        SBCI     XH, high(-1000)
     // don't print leading zeros
        BRTS     LCD_NUMBER2_PRINT          ;  any number (including zero) can be printed if t-flag set
        CPI      mpr, '0'                   ;  else if the number to print is a zero
        BREQ     LCD_NUMBER2_END            ;  it's a leading zero (don't print it)
LCD_NUMBER2_PRINT:
        RCALL    LCD_CHR
        SET                                 ;  set t-flag to know there are no more leading zeros
LCD_NUMBER2_END:
 
     // hundred
        LDI      mpr, '0'-1
LCD_NUMBER3:
        INC      mpr
        SUBI     XL, low(100)
        SBCI     XH, high(100)
        BRCC     LCD_NUMBER3
        SUBI     XL, -100                   ;  high byte can be ignored
     // don't print leading zeros
        BRTS     LCD_NUMBER3_PRINT          ;  any number (including zero) can be printed if t-flag set
        CPI      mpr, '0'                   ;  else if the number to print is a zero
        BREQ     LCD_NUMBER3_END            ;  it's a leading zero (don't print it)
LCD_NUMBER3_PRINT:
        RCALL    LCD_CHR
        SET                                 ;  set t-flag to know there are no more leading zeros
LCD_NUMBER3_END:

     // ten
        LDI      mpr, '0'-1
LCD_NUMBER4:
        INC      mpr
        SUBI     XL, 10
        BRCC     LCD_NUMBER4
        SUBI     XL, -10
        // don't print leading zeros
        BRTS     LCD_NUMBER4_PRINT          ;  any number (including zero) can be printed if t-flag set
        CPI      mpr, '0'                   ;  else if the number to print is a zero
        BREQ     LCD_NUMBER4_END            ;  it's a leading zero (don't print it)
LCD_NUMBER4_PRINT:
        RCALL    LCD_CHR
LCD_NUMBER4_END:
 
     // one
        LDI      mpr, '0'
        ADD      mpr, XL
        RCALL    LCD_CHR

     // load 16 bit number from stack
        POP      XH
        POP      XL
        POP      mpr                            ;  load mpr from stack

        RET                                     ; return from function

;==============================================================================
; @name:    TO_CHAR
; @description:
;  Converts a 4bit number to a hex ascii character
;
; @param {uint_4} mpr
;  The 4 bit number to convert into a ascii character 
;  (low nibble contains number)
;
; @return {char} mpr
;  The converted ascii character
;------------------------------------------------------------------------------
TO_CHAR:                                        ; converts number to hex ascii
       
       CPI         mpr, 0x09                    ;  when the number is
       BRLO        TO_CHAR_ELSEIF01             ;  lower then

    // convert character (A...F) to ascii
       SUBI        mpr, -0x37                   ;   convert to character (A...F)
       RJMP        TO_CHAR_ENDIF01              ;   don't execute else statement
    TO_CHAR_ELSEIF01:

    // convert number (1...9) to ascii
       SUBI        mpr, -0x30                   ;   convert to character (1...9)
    TO_CHAR_ENDIF01:

       RET                                      ; return form function


;==============================================================================
; DATA DEFFINITION
;------------------------------------------------------------------------------
string: 
        .db        "Hello World", 0
