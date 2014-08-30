#ifndef ATMEGA2560_H_
#define ATMEGA2560_H_

/* ATMEGA 2560 CONFIGURATION
 *
 * Configuration for the ATMega2560 Microcontroller
 */

#ifdef CONTROLLER
  #error You must only include one controller file
#endif

#define CONTROLLER ATMEGA2560

// Assumption that the default CPU frequency of 8MHz is set.
#ifndef F_CPU
  #warning No F_CPU speed specified - assuming running at 8MHz
  #define F_CPU 8000000
#endif


#if !defined (__AVR_ATmega2560__)
  #error If including atmega2560.h you must set the compiler to use the device ATMega2560
#endif

#endif // ATMEGA2560_H_
