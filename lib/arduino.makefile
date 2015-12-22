ARDUINO_BASE = arduino/
ARDUINO	= $(ARDUINO_BASE)/hardware/arduino/avr/cores/arduino/
ARDUINO_PINOUT = $(ARDUINO_BASE)/hardware/arduino/avr/variants/mega/

#ARDUINO = ../../../src/Network/arduino

BUILD_DIRECTORY = build/

# The core arduino files written in c
C_FILES = \
	wiring.c \
	wiring_analog.c \
	wiring_digital.c \
	wiring_shift.c \

# The arduino c++ source files (only the core
# files are used)
CPP_FILES = \
	new.cpp \
	Stream.cpp \
	Print.cpp \
	HardwareSerial.cpp \
	WString.cpp

# The object files that will be generated by the
# avr-gcc and avr-g++ and source for the archive
C_OBJECTS = $(addprefix $(C_FILES:.c=.o))
CPP_OBJECTS = $(addprefix $(CPP_FILES:.cpp=.o))

# Add a prefix to all source files that they can be found by the compiler
C_SOURCES = $(addprefix $(ARDUINO), $(C_FILES))
CPP_SOURCES = $(addprefix $(ARDUINO), $(CPP_FILES))

CFLAGS 		= -I$(ARDUINO) -I$(ARDUINO_PINOUT) -std=gnu99  -DF_CPU=16000000UL -Os -mmcu=atmega2560
CPPFLAGS 	= -I$(ARDUINO) -I$(ARDUINO_PINOUT) -DF_CPU=16000000UL -Os -mmcu=atmega2560

CC				= avr-gcc
CPP				= avr-g++
AR				= avr-ar

# Default target, create builddir and build the archive
default: builddir libarduino.a

libarduino.a: $(C_OBJECTS) $(CPP_OBJECTS)
	${AR} crs libarduino.a $(C_OBJECTS) $(CPP_OBJECTS)

$(C_OBJECTS): $(C_SOURCES)
	$(CC) $(CFLAGS) -c $< -o $@

$(CPP_OBJECTS): $(CPP_SOURCES)
	$(CPP) $(CPPFLAGS) -c $< -o $@

builddir:
	# make build directory if not exists
	mkdir -p $(BUILD_DIRECTORY)

clean:
	# Remove the build directory with all built files and the lib file
	rm -R $(BUILD_DIRECTORY)
	rm libarduino.a
