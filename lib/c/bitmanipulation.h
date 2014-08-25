#ifndef BITMANIPULATION_H_
#define BITMANIPULATION_H_

/**
* Set bit at position in a register
*/
#define SET_BIT(register, bit_position) (register |= (1 << bit_position))

/**
* Clear bit at position in a register
*/
#define CLEAR_BIT(register, bit_position) (register &= ~(1 << bit_position))

/**
* Invert bit at position
*/
#define INVERT_BIT(register, bit_position) (register ^= (1 << bit_position))

/**
* Check if bit at position is set
*/
#define IS_BIT_SET(register, bit_position) (register | (1 << bit_position))

#endif // BITMANIPULATION_H_
