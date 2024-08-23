// types also causing issues
const std = @import("std");
const start= @import("start.zig");
const uart = @import("uart.zig");

const delay = @import("delay.zig");

const avr = @import("ATMega328p.zig").avr;

const pulseIn = @import("pulse_duration.zig");

const operations = @import("operations.zig");

const motions = @import("motion.zig");

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
const zig_string: [:0]const u8 = "Hello dear 143 \n";

// const as_ptr: [*:0]const u8 = c_string;
pub fn intToString(value: u16, buf: []u8) [:0]const u8 {
    var v = value;
    var index: usize = buf.len - 1;
    
    // Ensure the buffer ends with a null terminator
    buf[index] = 0;
    
    // Handle the case when value is 0
    if (v == 0) {
        index -= 1;
        buf[index] = '0';
        return buf[index..:0];
    }

    while (v > 0) {
        index -= 1;
        const mod = operations.__udivmodhi4(v, 10, true);
        v = operations.__udivmodhi4(v, 10, false);
        const digit : u8 = @intCast((mod)+48);
        buf[index] = digit;
    }

    return buf[index..:0];
}

pub export fn main() noreturn {
    // avr.ddrb.* = (1 << 5);
    // avr.portb.* = (1 << 5);
    // start._start();
    uart._init();
    led.init(); 
    pulseIn.sonic.init();
    // delay.delay_1s();
    while (true){

        //################# driver_motor_control ##################
        motions.drive_motor.init();
        motions.controlled_dvr_mtn.mv_lft_90();
        
        
        
        pulseIn.sonic.trigger_init();
        
        const echo_duration : u16 = pulseIn.pulseIn(pulseIn.echo_pin, pulseIn.state_, 2000); //u8 - 25
        const distance = operations.__udivmodhi4(echo_duration,1000, false) * 34;
        
        uart.UART_send_byte("Distance : ");
        var buffer: [10]u8 = undefined; // Adjust size depending on your expected output
        const slice = intToString(distance/2, &buffer);
        
        uart.UART_send_byte(slice);
        if ((distance/2)>15){
            motions.controlled_motion.cntrl_fwd();
        } 
        // else if {} else if{} else{}



        
        led.toggle(); 
        // delay.delay_1s();

    }
} 

pub fn intToString8(value: u8, buf: []u8) [:0]const u8 {
    var v = value;
    var index: usize = buf.len - 1;
    
    // Ensure the buffer ends with a null terminator
    buf[index] = 0;
    
    // Handle the case when value is 0
    if (v == 0) {
        index -= 1;
        buf[index] = '0';
        return buf[index..:0];
    }

    while (v > 0) : (v /= 10) {
        index -= 1;
        const digit : u8 = @intCast((v%10)+48);
        buf[index] = digit;
    }

    return buf[index..:0];
}

// "/home/linux/.arduino15/packages/arduino/tools/avrdude/6.3.0-arduino17/bin/avrdude" 
// "-C/home/linux/.arduino15/packages/arduino/tools/avrdude/6.3.0-arduino17/etc/avrdude.conf" -v -patmega328p -cusbasp -Pusb 
// "-Uflash:w:/home/linux/simvr/space_detection_wheels/warmup.hex:i"


// zig build-obj -OReleaseSmall -target avr-freestanding-none -mcpu atmega328p /home/linux/simvr/space_detection_wheels/src/warmup.zig && 
// avr-ld -o warmup.elf warmup.o && avr-objcopy -j .text -j .data -O ihex warmup.elf warmup.hex && avr-objdump -D -h warmup.elf > warmup.dmp