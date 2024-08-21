// types also causing issues
const std = @import("std");

const uart = @import("uart.zig");

const delay = @import("delay.zig");

const avr = @import("ATMega328p.zig").avr;

const pulseIn = @import("pulse_duration.zig");
pub const led = struct {
    pub fn init() void {
        // Set PB5 (Arduino Uno built-in LED) as output
        avr.ddrb.* |= (1 << 5);
    }

    pub fn toggle() void {
        avr.portb.* ^= (1 << 5);
    }
};
// const c_string: [*c]u8 = "s";
const zig_string: []const u8 = "s";

// const as_ptr: [*:0]const u8 = c_string;

export fn main() noreturn {
    // avr.ddrb.* = (1 << 5);
    // avr.portb.* = (1 << 5);
    uart._init();
    led.init(); 
    delay.delay_1s();
    while (true){
        // pulseIn.sonic_init();
        // const duration : u16 = pulseIn.pulseIn(pulseIn.echo_pin, pulseIn.state_, 25000); //u8 - 25
        // const u8duration : u8 = @truncate(duration);
        // uart.UART_Transmit(10);
        // uart.UART_Transmit(65+u8duration);
        // because unable to transmitt i send charecter and infer the value of duration from it
        // const dist : u32 = duration*34; //m/us distance in mm
        // const dist_: u8 = @truncate((dist>>8)*3);

        const c_string: [*c]u8 = undefined;
        try uart.UART_send_byte(c_string);
        // uart.UART_Transmit(56);

        // uart.UART_Transmit(65+dist_);

        led.toggle(); 
        delay.delay_1s();

    }
} 


// "/home/linux/.arduino15/packages/arduino/tools/avrdude/6.3.0-arduino17/bin/avrdude" 
// "-C/home/linux/.arduino15/packages/arduino/tools/avrdude/6.3.0-arduino17/etc/avrdude.conf" -v -patmega328p -cusbasp -Pusb 
// "-Uflash:w:/home/linux/simvr/space_detection_wheels/warmup.hex:i"


// zig build-obj -OReleaseSmall -target avr-freestanding-none -mcpu atmega328p /home/linux/simvr/space_detection_wheels/src/warmup.zig && 
// avr-ld -o warmup.elf warmup.o && avr-objcopy -j .text -j .data -O ihex warmup.elf warmup.hex && avr-objdump -D -h warmup.elf > warmup.dmp