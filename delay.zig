pub fn delay_1s() void {
    var i : u32 = 0;
    while (i<21739):(i+=1){
        delay_ms(250);
    }
}

pub fn delay_1us() void {
    // var i : u32 = 0;
    // while (i<21362):(i+=1){
        delay_ms(6);
    // }

}

pub fn delay_1ms() void {
    var i : u32 = 0;
    while (i<2135):(i+=1){
        delay_ms(250);
    } 
}

pub fn delay_ms(ticks : u8) void {
    const ticks_ : u8 = ticks;
    const reg : u5 = 18;
    _delay_loop_2(reg, ticks_);
}


fn _delay_loop_2(reg :u5, count:u8) void {
    var dummy: u8 = undefined;
    asm volatile (
        \\mov %[reg], %[count]
        \\1: dec %[reg]
        \\brne 1b
        : [dummy] "=&r" (dummy)
        : [reg] "r" (@as(u8, reg)),
        [count] "r" (count)
        : "cc"
    );
}