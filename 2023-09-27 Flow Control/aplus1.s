.text
.global _start

ADR X0 a            // Get address of a
LDR X9, [X0]        // Get integer in $a, and load it in X9

CBZ X9, Two         // If X9 == 0, go to TWO
CBNZ X9, Four       // There is no else in Assembly. But !(X9 == 0) is just X9 != 0. Just use CBNZ.

Two:
MOV X9, 2           // X9 = 2
STR X9, [X0]        // Store the 2 back into the RAM slot represented by memory address X0. Basically, a = 2

B End               // Unconditional branching to stop Four from being executed in this case

Four:
MOV X9, 4           // Else: X9 = 4
STR X9, [X0]        // Store the 4 back into a (represented by memory address X0)

End:

.data
a: .int 4         // long int in C is just an int