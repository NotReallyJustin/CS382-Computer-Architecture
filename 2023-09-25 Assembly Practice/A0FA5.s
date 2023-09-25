.text
//Take a look at the components we need to add
//A[0] and f is fine as they're on the 0th index of the register
//But A[5] is acting wonky

//So first, we need to actually get A[5]
//Remember A is an int array. We want to load ONE INT (4 bytes)
//When you use LDR, make sure it's on a W register so we only load 4 bytes (as opposed to 8)
//Also remember A is an int array. 4 bytes per int array idx * 5 int array indices = 20 byte offset
LDR W9, [X21, 20]
//      ^^^ Also remember the address is X21 and not W21, because that stores an address
//      And addresses are 64 bits (8 bytes). We need an X register

ADD W9, W20, W9     //Using W register because integers are 4 bytes

//Don't forget to load the results back into A[0]
//Remember X21 points to the 0th index on the register
STR W9, [X21, 0]