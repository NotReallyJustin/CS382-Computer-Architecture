.text
.global _start          //STOP HERE! Read _start first

_addition:
ADD X0, X0, X1          //Adds parameters X0 and X1, and chucks them into return
RET

_start:

//First, let's get the address of a, b, and c.
ADR X9, a
ADR X10, b
ADR X11, c

//Before we call add, we need to pass in the variables in RAM into the parameter section
LDR X0, [X9]
LDR X1, [X10]

//Now, call the function _addition
BL _addition            //Branch and link addition. Recall this changes X30

STR X0, [X11]           //Stores the argument we get (X0) back into .c

.data
a: .quad 10
b: .quad 20
c: .quad