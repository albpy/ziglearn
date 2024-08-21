# ziglearn
help me to learn zig on 328p


Hi I am trying to implement uart on atmega328p using zig. 
But I wasn't able to transmit the message to the serial monitor. I've googled a lot but no resources are available regarding it.  I am able to build the hex file using the build-obj command and successfully uploaded the blink. But uart not working. I'm able to send a single character but while sending string it shows no output . All the configurations are correct including baud rate. I tried it in c and it succeeded. I'm new to zig and trying to learn the zig embedded system. I sat the whole day debugging it and no results. Maybe it's regarding the zig style of strings! But I can't move forward and I want to integrate the Hc-sr04 module to 328p through zig. But zig is a great language

## ATMega328p.zig
Contains the Registers used for UART and the sonic sensor
## delay.zig 
contains delays for Uart and sonic sensor initialization
## main.zig
entry...
## uart.zig
uart functions for send data. Im only using Tx
## pulse_duraion.zig
duration measurement using echo pin & trig pin of hc-sro4 module
