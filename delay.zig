pub fn delay_1s() void {
    var i : u32 = 0;
    while (i<21739):(i+=1){
        delay_ms();
    }
}

pub fn delay_1ms() void {
    var i : u32 = 0;
    while (i<5333):(i+=1){
        delay_ms();
    }
}
pub fn delay_ms() void {
    const ticks : u8 = 250;
    const reg : u5 = 18;
    _delay_loop_2(reg, ticks);
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