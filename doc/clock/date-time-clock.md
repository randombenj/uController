#date-time-clock

##contents

* [description and requirements](#description and requirements)
    * [requirements](#requirements)
* [how to use](#how-to-use)
    * [register names](#register-names)
    * [code initialisation](#code-initialisation)

##description and requirements

The "date-time-clock" calculates date and time from initial values (date and time).
Whe initialising the clock, only set the values of "hh:mm:ss DD.MM.YY"
everithing else will be calculated in "DT_Handle".

###requirements

* time calculation     *hh:mm:ss*
* date calculation     *DD.MM.YY*
* week numbering       *Www*
* calender week        *D*
* leap year til 2099
* summer- and wintertime

##how to use

###register names

These are the required register names:
(8-bit registers) [ISO 8601](http://en.wikipedia.org/wiki/ISO_8601)

```nasm
;-- Date-time variables (ISO 8601: http://en.wikipedia.org/wiki/ISO_8601) ---

.def    hh          = R17       ; houers register
.def    mm          = R18       ; minutes register
.def    ss          = R19       ; seconds register

.def    DD          = R20       ; day register    
.def    MO          = R21       ; month register (because non key sensitive)
.def    YY          = R22       ; year register (two digits > 2000-2099)

.def    Www         = R23       ; calender week register (W01-W53)
.def    D           = R24       ; week day register (1-7)
```  

###code initialisation

To use the date-time-clock you must user your own "sleep-one-second" function.
In this case I used the **W1S** function from my delay.inc file.

```nasm
;--- main function ---	
Main:		                        ;  [Main()] function
        
        RCALL   W1S                 ;    W1S() - wait one second
        RCALL   DT_Handle           ;    DT_Handle() - handles the date-time-clock

        RJMP    Main                ;  Endless Loop 
```
