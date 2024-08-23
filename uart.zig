const avr = @import("ATMega328p.zig").avr;
const delay = @import("delay.zig");
const std = @import("std");

// const uart_c = @cImport({
//     @cInclude("/home/albin/Downloads/zig-linux-x86_64-0.14.0/wheels/_uart.c");
// });
pub fn _init() void {
    avr.UBRRH.* = (103 >> 8);
    avr.UBRRL.* = (103);


    avr.UCSR0B.* = (1 << 3);
    // xcki Input from XCK pin (internal Signal). Used for synchronous slave operation.
    // xcko Clock output to XCK pin (Internal Signal). Used for synchronous master operation.
    // If UCPOLn is set, the data will be changed at falling XCKn edge and sampled at rising XCKn edge
    avr.UCSR0C.* =(1<<1) | (1<<2); // synchronous mode
}

pub fn UART_send_byte(s: [] const u8) void {

    for (s) |e|{
        UART_Transmit(e);
    }
    UART_Transmit(10);
    // delay.delay_1ms();
    // delay.delay_1ms();
        // s+=1;
    // while ((avr.UCSR0A.* & (1 << 6)) == 0) {} // Wait for transmission complete
    // }
}
fn UART_Transmit(ch : u8) void {
    while((avr.UCSR0A.* & (1 << 5))==0) {
    }
    avr.UDR0.* = ch;

}