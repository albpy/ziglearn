const std = @import("std");

pub const trig_pin : u8 = 1 << 3;
pub const echo_pin : u8 = 1 << 2;
// out state is always high for this application.
pub const state_ : u8 = 1 << 3;
const delay = @import("delay.zig");

const avr = @import("ATMega328p.zig").avr;

const uart = @import("uart.zig");


pub fn sonic_init() void {
    avr.ddrd.* |= trig_pin;
    avr.ddrd.* &= ~(echo_pin);

    // const cur_val = avr.portd.*;
    avr.portd.* |= ~(trig_pin);
    delay.delay_1ms();
    delay.delay_1ms();
    avr.portd.* |= (1<<3);
    delay.delay_1ms();
    delay.delay_1ms();
    delay.delay_1ms();
    delay.delay_1ms();
    delay.delay_1ms();
    delay.delay_1ms();
    delay.delay_1ms();
    delay.delay_1ms();
    delay.delay_1ms();
    delay.delay_1ms();
    avr.portd.* |= ~(trig_pin);

}
// state is pin bimask
pub fn pulseIn(echo : u8, state : u8, timeout : u16) u16 {
    _ = echo;
    // bit = digitalPinToBitMask(pin); return the mask of that pin
    // uint8_t port = digitalPinToPort(pin); // port address
    // portInputRegister(port)-> pin; return the input reading address of the port
    // state - which state want to start measure(high/low) ; we want high of pin 3 of port d(00001000)
    const stateMask : u8 = if (state == echo_pin) echo_pin else 0; 
    // #define clockCyclesPerMicrosecond() ( F_CPU / 1000000L )
    // microsecondsToClockCycles -  #define microsecondsToClockCycles(a) ( (a) * clockCyclesPerMicrosecond() )

    const maxloops : u16 = timeout*16; // timeout in clock_cycles // to do



    const width : u16 = countPulseASM(avr.pind, stateMask, maxloops);
    // const wid : u8 = @truncate(width);
    // uart.UART_Transmit(wid*3);

    // prevent clockCyclesToMicroseconds to return bogus values if countPulseASM timed out
    // #define clockCyclesPerMicrosecond() ( F_CPU / 1000000L )
    // #define clockCyclesToMicroseconds(a) ( (a) / clockCyclesPerMicrosecond() )
	// if (width>0){
        // const divisor : u8 = 100;
        
    const widt :u16 = ((width * 16 + 16) / 16); // to do
    // const wi: u8 = @truncate(widt);

    return widt;
}




fn countPulseASM(pind : *volatile u8, stateMask : u8, maxloop : u16) u16 {
    var maxloops = maxloop;
    var width : u16 = 0;
    // wait for any previous pulse to end
    // if pind turns up on pd3 
    while ((pind.* & echo_pin) == stateMask){
        // uart.UART_Transmit(66);

        maxloops -= 1;
        if (maxloops == 0){
            uart.UART_Transmit('T');  // Timeout in first loop
            return 0;
        }
    }
    uart.UART_Transmit(69); // first loop completed

    // wait for the pulse to start
    while ((pind.* & echo_pin) != stateMask){
        // uart.UART_Transmit(67);

        if (maxloops == 0){
            uart.UART_Transmit('S');  // Timeout waiting for start
            return 0;
        }
        maxloops -= 1;
    }
    uart.UART_Transmit(70); //sec loop completed

    //  wait for the pulse to stop
    while ((pind.* & echo_pin) == stateMask) {

        if (width == maxloops){
            uart.UART_Transmit('V');  // Timeout in measurement loop
            return 0;
        }
        width += 1;

    }
    uart.UART_Transmit(71); // last loop

    if (width == 0) {
        uart.UART_Transmit('Z');  // Zero width detected
    }

    return width;
}


// unsigned long pulseInSimpl(volatile uint8_t *port, uint8_t bit, uint8_t stateMask, unsigned long maxloops) u32
// {
    // unsigned long width = 0;
    // wait for any previous pulse to end
    // while ((*port & bit) == stateMask)
        // if (--maxloops == 0)
            // return 0;
    //  wait for the pulse to start
    // while ((*port & bit) != stateMask)
        // if (--maxloops == 0)
            // return 0;
    //  wait for the pulse to stop
    // while ((*port & bit) == stateMask) {
        // if (++width == maxloops)
            // return 0;
    // }
    // return width;
// }