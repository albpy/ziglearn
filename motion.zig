const std = @import("std");
const avr = @import("ATMega328p.zig").avr;
const delay = @import("delay.zig");

export var x: u16 = 0; // added export keyword

const enable_left = 1 << 4;     // left wheel PD4
const left_backward = 1 << 5;   // PD5 IN1
const left_forward = 1 << 6;    // PD6 IN2

const enable_right = 1;         //PB0
const right_backward = 1 << 7;  // IN3 PD7
const right_forward = 1 << 2;   // PB2 IN4




const wheels = struct {
    
    pub fn init() void {
         // Set trigPin as output
        avr.ddrd.* |= enable_left | left_backward | left_forward | right_backward;

        // Set echoPin as input
        avr.ddrb.* |= enable_right | right_forward;
    }
    // ####################################
    pub fn enable_left_wheel() void {
        avr.portd.* = enable_left;
    }

    pub fn move_left_backward() void {
        avr.portd.* = left_backward;
    }

    pub fn move_left_forward()void {
        avr.portd.* = left_forward;
    }
    // #####################################
    pub fn enable_right_wheel() void {
        avr.portb.* |= 1 << 0; 
    }

    pub fn move_right_forward() void {
        avr.portb.* &=  ~@as(u8, right_backward);
        avr.portb.* |= right_forward; 
    }

    pub fn move_right_backward() void {
        avr.portb.* &=  ~@as(u8, right_forward);
        avr.portd.* |= right_backward; 
    }
    // ######################################

    pub fn stop_left_fw_motion() void {
        // @as -  zig not perform binary not operation on type 'comptime_int'
        avr.portd.* &=  ~@as(u8, 1 << 6);
    }

    pub fn stop_left_bw_motion() void {
        avr.portd.* &=  ~@as(u8, 1 << 5);
    }

    // ###################################### Stop right
    pub fn stop_right_fw_motion() void {
        // @as -  zig not perform binary not operation on type 'comptime_int'
        avr.portb.* &=  ~@as(u8, right_forward);
    }

    pub fn stop_right_bw_motion() void {
        avr.portd.* &=  ~@as(u8, right_backward);
    }

    pub fn fwd() void {
        avr.portd.* = left_forward;
        avr.portb.* |= right_forward; 
    }
    pub fn stop_fwd() void {
        avr.portd.* &=  ~@as(u8, 1 << 6); // stop left fwd
        avr.portb.* &=  ~@as(u8, right_forward); //stop right fwd

    }

    pub fn bwd() void {
        avr.portd.* = left_backward; //move left bwd
        avr.portd.* |= right_backward; 

    }

    pub fn stop_bwd() void {
        avr.portd.* &=  ~@as(u8, right_backward); // stop right bwd
        avr.portd.* &=  ~@as(u8, 1 << 5); // stop left bwd

    }
};

pub const drive_motor = struct {
    pub fn init()void{
        // A3 -> Enable 1 -> PC3
        // A4 -> IN2      -> PC4(SDA)
        // A5 -> IN1      -> PC5(SCL)
        avr.ddrc.* |= (1<<3) | (1<<4) | (1<<5); // set driver motor pins out
        avr.portc.* |= (1<<3); // turn enable pin

    }

    pub fn mv_lft() void {
        avr.portc.* |= 1<<5;
        avr.portc.* &= ~@as(u8, 1<<4);
    }

    pub fn mv_rgt() void {
        avr.portc.* |= 1<<4;
        avr.portc.* &= ~@as(u8, 1<<5);
    }

    pub fn stp_motion() void {
        avr.portc.* &= ~@as(u8, 1<<4);
        avr.portc.* &= ~@as(u8, 1<<5);
    }
};


pub const controlled_dvr_mtn = struct {
    pub fn mv_lft_90() void {
        drive_motor.mv_lft();
        delay.delay_1ms();
        delay.delay_1ms();
        // delay.delay_1s();
        // drive_motor.stp_motion();
    }
};

pub const controlled_motion = struct{
    pub fn cntrl_fwd() void {
        wheels.fwd();
        delay.delay_1ms();
            
        wheels.stop_fwd();
        delay.delay_1s();
    }
};

// zig build-obj -OReleaseSmall -target avr-freestanding-none -mcpu atmega328p /home/linux/simvr/space_detection_wheels/wheels/left.zig 
// && avr-ld -o left.elf left.o && avr-objcopy -j .text -j .data -O ihex left.elf left.hex && avr-objdump -D -h left.elf > left.dmp

// "/home/linux/.arduino15/packages/arduino/tools/avrdude/6.3.0-arduino17/bin/avrdude" 
// "-C/home/linux/.arduino15/packages/arduino/tools/avrdude/6.3.0-arduino17/etc/avrdude.conf" -v -patmega328p -cusbasp 
// -Pusb "-Uflash:w:/home/linux/simvr/space_detection_wheels/wheels/left.hex:i"