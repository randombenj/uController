#ifndef BITMANIPULATION_H_
#define BITMANIPULATION_H_

/**
 * Set bit at position in a register
 */
#define SET_BIT(value, bit_position) (value |= (1 << bit_position))

/**
 * Clear bit at position in a register
 */
#define CLEAR_BIT(value, bit_position) (value &= ~(1 << bit_position))

/**
 * Invert bit at position
 */
#define INVERT_BIT(value, bit_position) (value ^= (1 << bit_position))

/**
 * Check if bit at position is set
 */
#define IS_BIT_SET(value, bit_position) (value & (1 << bit_position))

/**
 * Swap Nibbles of a byte
 */
#define SWAP_NIBBLES(value) (((value >> 4) & 0x0F) | ((value << 4) & 0xF0))

#endif // BITMANIPULATION_H_
