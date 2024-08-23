const std = @import("std");

pub const trig_pin : u8 = 1 << 3;
pub const echo_pin : u8 = 1 << 2;
// out state is always high for this application.
pub const state_ : u8 = 1 << 2;
const delay = @import("delay.zig");

const avr = @import("ATMega328p.zig").avr;

const uart = @import("uart.zig");

const main = @import("main.zig");

pub const sonic =  struct {
    pub fn init() void {
        // Set trig pin as output on PORTD
        avr.ddrd.* |= trig_pin;
        
        // Set echo pin as input on PORTD
        avr.ddrd.* &= ~(echo_pin);
   
    }
    pub fn trigger_init() void {
            avr.portd.* &= ~(trig_pin);
            delay.delay_1us();
            delay.delay_1us();
            // delay.delay_1s();

            avr.portd.* |= (trig_pin);
            delay.delay_1us();
            delay.delay_1us();
            delay.delay_1us();
            delay.delay_1us();
            delay.delay_1us();
            delay.delay_1us();
            delay.delay_1us();
            delay.delay_1us();
            delay.delay_1us();
            delay.delay_1us();
            avr.portd.* &= ~(trig_pin);
            // delay.delay_1s();
    }
};
//     sonic_init() void {


//     // const cur_val = avr.portd.*;
//     avr.portd.* |= ~(trig_pin);
//     // delay.delay_1ms();
//     // delay.delay_1ms();
//     delay.delay_1s();

//     avr.portd.* |= (trig_pin);
//     delay.delay_1ms();
//     delay.delay_1ms();
//     delay.delay_1ms();
//     delay.delay_1ms();
//     delay.delay_1ms();
//     delay.delay_1ms();
//     delay.delay_1ms();
//     delay.delay_1ms();
//     delay.delay_1ms();
//     delay.delay_1s();
//     avr.portd.* |= ~(trig_pin);
//     delay.delay_1s();

//     // delay.delay_1s();
//     // delay.delay_1s();
//     // delay.delay_1s();


// }
// state is pin bimask
pub fn pulseIn(echo : u8, state : u8, timeout : u16)  u16 {
    _ = echo;
    // bit = digitalPinToBitMask(pin); return the mask of that pin
    // uint8_t port = digitalPinToPort(pin); // port address
    // portInputRegister(port)-> pin; return the input reading address of the port
    // state - which state want to start measure(high/low) ; we want high of pin 3 of port d(00001000)
    const stateMask : u8 = if (state == echo_pin) echo_pin else 0; 
    // #define clockCyclesPerMicrosecond() ( F_CPU / 1000000L )
    // microsecondsToClockCycles -  #define microsecondsToClockCycles(a) ( (a) * clockCyclesPerMicrosecond() )
    // var buffer: [1]u8 = undefined; 
    // const pin_d_2_val : u16 = avr.pind.*; 
    var widt : u16 = undefined;
    if (avr.pind.* == 0) {
        uart.UART_send_byte("echo_pin 0");
    }
    

    const maxloops : u16 = timeout*16; // timeout in clock_cycles // to do
    // _ = stateMask;
    // _ = maxloops;

    const width : u16 = countPulseASM(avr.pind, stateMask, maxloops);
    // _ = width;
    // time echo pin stayed up
    if (width < 4093){
        widt = ((width * 16 + 16) / 16); // to do
    } else {
        widt = width; 
    }
    // var buffer: [10]u8 = undefined; 
    // const width_str = main.intToString(widt, &buffer);//
    // uart.UART_send_byte("Final width");
    // uart.UART_send_byte(width_str);
    
    // _ = widt;
    // var buffer: [10]u8 = undefined; 
    // const width_str = main.intToString(width, &buffer);//
    // uart.UART_send_byte(width_str);  // Timeout waiting for start

    // _ = widt;
    // const wi: u8 = @truncate(widt);

    return widt;
    // return 100;

}




fn countPulseASM(pind : *volatile u8, stateMask : u8, maxloop : u16) u16 {
    var maxloops = maxloop;
    var width : u16 = 0;
    // wait for any previous pulse to end
    // if pind turns up on pd3 
    while ((pind.* & echo_pin) == stateMask){
        // uart.UART_send_byte(66);
        // uart.UART_send_byte("fl");
        maxloops -= 1;
        if (maxloops == 0){
            uart.UART_send_byte("Fi\n");  // Timeout in first loop
            return 0;
        }
    }
    // uart.UART_send_byte("First loop completed\n"); // first loop completed

    // wait for the pulse to start
    while ((pind.* & echo_pin) != stateMask){
        // uart.UART_send_byte(67);hjhjh
        // uart.UART_send_byte("second loop in\n");
        // delay.delay_1s();
        
        if (maxloops == 0){
            uart.UART_send_byte("Sl");  // Timeout waiting for start
            return 0;
        }
        // delay.delay_1s();
        // delay.delay_1s();
        maxloops -= 1;
    }
    // uart.UART_send_byte("Second loop completed\n"); // first loop completed
    // delay.delay_1s();
    // delay.delay_1s();
    // delay.delay_1s();
    // delay.delay_1s();
    // delay.delay_1s();


    //  wait for the pulse to stop
    while ((pind.* & echo_pin) == stateMask) {

        if (width == maxloops){
            uart.UART_send_byte("T\n");  // Timeout in measurement loop
            return 0;
        }
        width += 1;
        // uart.UART_send_byte("W");

    }
    uart.UART_send_byte("3rd loop completed\n"); // first loop completed
    
    if (width == 0) {
        uart.UART_send_byte("width zero\n");  // Zero width detected
    }else{
        var buffer: [10]u8 = undefined; 
        const width_str = main.intToString(width, &buffer);//
        uart.UART_send_byte(width_str);
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