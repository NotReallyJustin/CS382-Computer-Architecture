.data
str: .ascii "012"

.text

//First thing we want to do is actually get where "012" is
ADR X2, str

//LDR loads 4 byes. We don't like that. 
//Use LDRB to load 1 byte (value of ASCII) instead
//We store it in the W register since LDRB/STRB works only with W registers
LDRB W1, [X2, 0]

//Here's where the protip comes in. ASCII addition works
ADD W1, W1, 1

//Now, remember we also need to update "**0** 12" in the memory
//Things are kinda useless if it only stays on register
STRB W1, [X2, 0]

//Now repeat for the other 2 digits
LDRB W1, [X2, 1]
ADD W1, W1, 1
STRB W1, [X2, 1]
LDRB W1, [X2, 2]
ADD W1, W1, 1
STRB W1, [X2, 2]