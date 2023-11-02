/**
 * Name: Justin Chen
 * Pledge: I pledge my honor that I have abided by the Stevens Honor System
 */

.text
.global _start

_start:
ADR X19, numstr         // Find the address of numstr and store it in X19
ADR X20, number         // Find the address of number and store it in X20

//Step 1: Find the string length

MOV X9, 0               // Create a loop control variable that also access string variables

strlen_loop:
    LDRB W12, [X19, X9] // Loads number[i] into W12

    CMP W12, 0          // Compares W12 to the null terminator
    B.EQ continue       // If our number[i] is the null terminator, get out of the loop

    ADD X9, X9, 1       // Else, increment loop counter
    B strlen_loop       // Branch to strlen_loop

continue:
//The loop control variable can be used as multiplication

SUB X9, X9, 1           // Subtracts 1 from X9 so we avoid the loop counter variable
LDR X21, [X20]          // Loads the initial number into X21
MOV X10, 1              // Initializing X10 to 1
MOV X11, 10             // Initializes X11 to 10, we will multiply by that
MOV X22, 48             // Set X22 to 48, that is what we subtract ASCII value by 48

convert_loop:
    LDRB W12, [X19, X9] // Loads number[i] into W12. Recall that we are looping back now

    CMP X9, 0           // Compare X9 and 0
    B.LT boop           // Exit the loop if i < 0 (index out of bounds)

    SUB X13, X12, X22   // Convert the ASCII string to actual numbers we can use
    MUL X13, X13, X10   // Multiplies X13 by X10 (The place value multiplying by 10)
    ADD X21, X21, X13   // Add X13 (the converted ASCII number) into X21

    //End loop
    SUB X9, X9, 1       // Decrement loop control variable by 1
    MUL X10, X10, X11   // Multiplies X10 by 10
    B convert_loop      // Jump back to convert loop

boop:
//Store our calculated number into number
STR X21, [X20]          // Stores our calculated number value back into X21

/* Do not change any part of the following code */
exit:
    MOV  X0, 1
    ADR  X1, number
    MOV  X2, 8
    MOV  X8, 64
    SVC  0
    MOV  X0, 0
    MOV  X8, 93
    SVC  0
    /* End of the code. */


/*
 * If you need additional data,
 * declare a .data segment and add the data here
 */






