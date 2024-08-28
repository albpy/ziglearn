### Im not using a build file : i'm uaing build-obj command with avr-gcc

#### UPLOAD CMD:-
###### "/home/linux/.arduino15/packages/arduino/tools/avrdude/6.3.0-arduino17/bin/avrdude" "-C/home/linux/.arduino15/packages/arduino/tools/avrdude/6.3.0-arduino17/etc/avrdude.conf" -v -patmega328p -cusbasp -Pusb "-Uflash:w:warmup.hex:i"

###### avrdude -v -patmega328p -cusbasp -Pusb "-Uflash:w:warmup.hex:i"
####### OR 
###### avrdude  -v -patmega328p -cusbasp -Pusb "-Uflash:w:firmware/prog.hex:i"

#### BUILD CMD-:
###### zig build-obj -OReleaseSmall -target avr-freestanding-none -mcpu atmega328p main.zig && avr-ld -o firmware/prog.elf main.o && avr-objcopy -j .text -j .data -O ihex firmware/prog.elf firmware/prog.hex && avr-objdump -D -h firmware/prog.elf > firmware/prog.dmp

#### BUILD USING linker script:
###### zig build-obj -fno-strip  -OReleaseSmall -target avr-freestanding-none -mcpu atmega328p main.zig && avr-ld -o firmware/prog.elf -T linker.ld  main.o && avr-objcopy -j .text -j .data -O ihex firmware/prog.elf firmware/prog.hex && avr-objdump -D -h firmware/prog.elf > firmware/prog.dmp

#### BUILD WITH DEBUD INFORMATION:
###### zig build-obj -fno-strip  -OReleaseSmall -target avr-freestanding-none -mcpu atmega328p main.zig && avr-ld -o firmware/prog.elf main.o && avr-objcopy -j .text -j .data -O ihex firmware/prog.elf firmware/prog.hex && avr-objdump -D -h firmware/prog.elf > firmware/prog.dmp

#### BUILD WITH ASM main.s FILE
###### ../zig build-obj -femit-asm  -OReleaseSmall -target avr-freestanding-none -mcpu atmega328p main.zig && avr-ld -o firmware/prog.elf main.o && avr-objcopy -j .text -j .data -O ihex firmware/prog.elf firmware/prog.hex && avr-objdump -D -h firmware/prog.elf > firmware/prog.dmp

###### add linker.ld by avr-ld -o firmware/prog.elf -T linker.ld  main.o
