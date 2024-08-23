pub const avr = struct {
    pub const pinb : *volatile u8  = @ptrFromInt(0x23);
    pub const ddrb : *volatile u8  = @ptrFromInt(0x24);
    pub const portb : *volatile u8 = @ptrFromInt(0x25);

    pub const pinc : *volatile u8 = @ptrFromInt(0x26);
    pub const ddrc : *volatile u8 = @ptrFromInt(0x27);
    pub const portc : *volatile u8 = @ptrFromInt(0x28); 

    pub const pind : *volatile u8  = @ptrFromInt(0x29); //reads    
    pub const ddrd : *volatile u8  = @ptrFromInt(0x2A);
    pub const portd : *volatile u8  = @ptrFromInt(0x2B);

    // ### UART

    pub const UCSR0A : *volatile u8  = @ptrFromInt(0xC0);
    pub const UCSR0B : *volatile u8  = @ptrFromInt(0xC1);
    pub const UCSR0C : *volatile u8  = @ptrFromInt(0xC2);
    
    pub const UBRRH : *volatile u8  = @ptrFromInt(0xC5);
    pub const UBRRL : *volatile u8  = @ptrFromInt(0xC4);


    pub const UDR0 : *volatile u8  = @ptrFromInt(0xC6);

};