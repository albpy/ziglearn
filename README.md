## Help me tolearn zig by doing

### Im not using a build file : i'm uaing build-obj command with avr-gcc

Hi I am trying to implement uart on atmega328p using zig. But I wasn't able to transmit the message to the serial monitor. I've googled a lot but no resources are available regarding it.  I am able to build the hex file using the build-obj command and successfully uploaded the blink. But uart not working. I'm able to send a single character but while sending string it shows no output . All the configurations are correct including baud rate. I tried it in c and it succeeded. I'm new to zig and trying to learn the zig embedded system. I sat the whole day debugging it and no results. Maybe it's regarding the zig style of strings! But I can't move forward and I want to integrate the Hc-sr04 module to 328p through zig. But zig is a great language

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
