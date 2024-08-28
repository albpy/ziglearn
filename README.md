

#### UPLOAD CMD:-
avrdude "-Cavrdude.conf" -v -patmega328p -cusbasp -Pusb "-Uflash:w:start.hex:i"

####### OR 
avrdude  -v -patmega328p -cusbasp -Pusb "-Uflash:w:firmware/prog.hex:i"

#### BUILD CMD-:
###### zig build-obj -OReleaseSmall -target avr-freestanding-none -mcpu atmega328p main.zig && avr-ld -o firmware/prog.elf main.o && avr-objcopy -j .text -j .data -O ihex firmware/prog.elf firmware/prog.hex && avr-objdump -D -h firmware/prog.elf > firmware/prog.dmp

#### BUILD USING linker script:
zig build-obj -fno-strip  -OReleaseSmall -target avr-freestanding-none -mcpu atmega328p main.zig && avr-ld -o firmware/prog.elf -T linker.ld  main.o && avr-objcopy -j .text -j .data -O ihex firmware/prog.elf firmware/prog.hex && avr-objdump -D -h firmware/prog.elf > firmware/prog.dmp

#### BUILD WITH DEBUG INFORMATION:
add "-fno-strip" along with build-obj

#### BUILD WITH ASM main.s FILE
add "-femit-asm" along with build-obj

###### add linker.ld by avr-ld -o firmware/prog.elf -T linker.ld  main.o
