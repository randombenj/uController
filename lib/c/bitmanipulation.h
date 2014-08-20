/**
* Set bit at position in a register
*/
#define set_bit(register, bit_position) register |= (bit_position << 1)

/**
* Clear bit at position in a register
*/
#define clear_bit(register, bit_position) register &= ~(bit_position << 1)

/**
* Check if bit at position is set
*/
#define is_bit_set(register, bit_position) register | (bit_position << 1)
