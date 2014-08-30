TARGET              = lcd
SRC                 = $(TARGET).c
LIBS                = ../../../lib/c/bitmanipulation.h lcd.h ../../../lib/c/type.h

MCU                 = atmega2560
AVRDUDE_PROGRAMMER  = stk600
AVRDUDE_PORT        = usb
AVRDUDE_OPTIMIZE    = -Os
CC                  = avr-gcc
BUILD_DIRECTORY     = build

# Override is only needed by avr-lib build system.

override CFLAGS     = -g -Wall $(AVRDUDE_OPTIMIZE) -mmcu=$(MCU)
override LDFLAGS    = -Wl,-Map,$(BUILD_DIRECTORY)/$(TARGET).map

OBJCOPY             = avr-objcopy
OBJDUMP             = avr-objdump

all: builddir $(TARGET).elf lst text


$(TARGET).elf: $(TARGET).o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(BUILD_DIRECTORY)/$@ $(BUILD_DIRECTORY)/$^ $(LIBS)

builddir:
	mkdir -p $(BUILD_DIRECTORY) # make build directory if not exists

clean:
	rm -R $(BUILD_DIRECTORY)

lst:  $(TARGET).lst

%.lst: %.elf
	$(OBJDUMP) -h -S $(BUILD_DIRECTORY)/$< > $(BUILD_DIRECTORY)/$@

# Rules for building the .text rom images

text: hex bin srec

hex:  $(BUILD_DIRECTORY)/$(TARGET).hex
bin:  $(BUILD_DIRECTORY)/$(TARGET).bin
srec: $(BUILD_DIRECTORY)/$(TARGET).srec

%.o: %.c
	$(CC) $(CFLAGS) -c -o $(BUILD_DIRECTORY)/$@ $^

%.hex: %.elf
	$(OBJCOPY) -j .text -j .data -O ihex $< $@

%.srec: %.elf
	$(OBJCOPY) -j .text -j .data -O srec $< $@

%.bin: %.elf
	$(OBJCOPY) -j .text -j .data -O binary $< $@

# command to program chip (invoked by running "make install")
install:	$(BUILD_DIRECTORY)/$(TARGET).hex
	avrdude -p $(MCU) -c $(AVRDUDE_PROGRAMMER) -P $(AVRDUDE_PORT) -U flash:w:$(BUILD_DIRECTORY)/$(TARGET).hex
