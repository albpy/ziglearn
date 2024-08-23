// Functions starting with double underscores are often internal, compiler-generated, or runtime library functions. 
// They are usually not intended to be called directly by user code but are instead invoked by the compiler to implement 
// certain operations (like division) that might not have a direct machine instruction.
//   hi: This stands for "half-integer," indicating that the function operates on 16-bit (or half-word) unsigned integers. 
// In this context, "hi" differentiates it from "si" (which would indicate a signed integer) or "qi" (which would indicate an 8-bit quantity).

pub fn __udivmodhi4 ( numerator : u16, denominator : u16, modwanted : bool) u16 {
    var bit : u16 = 1;
    var res : u16 = 0;
    var den = denominator;
    var numr = numerator; 
    while (den < numr and bit!=0 and (den & (1<<15))==0){ 
        den <<= 1;
        bit <<= 1;
    }
    while (bit!=0){
    
        if (numr >= den){
	        numr -= den;
	        res |= bit;
	    }
        bit >>=1;
        den >>=1;
    }
  
  if (modwanted) { 
    return numr;
  }else{
    return res;
  }
}


// unsigned short
// __udivmodhi4(unsigned short num, unsigned short den, int modwanted)
// {
//   unsigned short bit = 1;
//   unsigned short res = 0;

//   while (den < num && bit && !(den & (1U<<15)))
//     {
//       den <<=1;
//       bit <<=1;
//     }
//   while (bit)
//     {
//       if (num >= den)
// 	{
// 	  num -= den;
// 	  res |= bit;
// 	}
//       bit >>=1;
//       den >>=1;
//     }
//   if (modwanted) return num;
//   return res;
// }