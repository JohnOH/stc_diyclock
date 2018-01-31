SDCC ?= sdcc
SDCCOPTS ?= --iram-size 256 --code-size 4089 --xram-size 0 --opt-code-size --peep-asm --peep-return --std-sdcc11
STCGAL ?= stcgal/stcgal.py
STCGALOPTS ?= -P stc15a 
STCGALPORT ?= /dev/ttyUSB0
FLASHFILE ?= main.hex
SYSCLK ?= 11059

SRC = src/adc.c src/ds1302.c src/led.c

OBJ=$(patsubst src%.c,build%.rel, $(SRC))

all: main

build/%.rel: src/%.c
	mkdir -p $(dir $@)
	$(SDCC) $(SDCCOPTS) -o $@ -c $<

main: $(OBJ)
	$(SDCC) -o build/ src/$@.c $(SDCCOPTS) $^
	cp build/$@.ihx $@.hex
	
flash:
	$(STCGAL) -p $(STCGALPORT) -t $(SYSCLK) $(STCGALOPTS) $(FLASHFILE)

clean:
	rm -f *.ihx *.hex *.bin
	rm -rf build/*

