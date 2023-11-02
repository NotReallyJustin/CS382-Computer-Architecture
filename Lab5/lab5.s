/*
Justin Chen & Amartya Kalra
I pledge my honor that I have abided by the Stevens Honor System.
 */
.text
.global _start
.extern printf


/* char _uppercase(char lower) */
_uppercase:
    // Since this is a leaf procedure, we are not changing X30.
    // Hence, we don't need to allocate extra data to store the original return address

    SUB W0, W0, 32      // Subtract ASCII by 32 to get uppercase
    RET


/* int _toupper(char* string) */
/* X0 should be the string we're inputting */
_toupper:
    SUB sp, sp, 8      // Allocate 8 bytes in the stack 
    STR X30, [sp]       // Store the intended return address of _toupper to X30
    MOV X10, X0     // Moves the address of the string (X0) into X10, because X0 will end up changing

    MOV X8, 0          // Counter variable that increments by 1 every time to loop through string (X0)

    loop:
        LDRB W9, [X10, X8]    // Fetch string[i], or more accurately, address of string[i]

        CMP W9, 0               // Compare it with null terminator to see if string has ended. 
        B.EQ end                // If it is the null terminator, jump to end

        MOV W0, W9              // Move the current letter into register into X0 because we're about to call uppercase()
        BL _uppercase           // Call uppercase
        MOV W9, W0              // Take the uppercase letter, and move it back into W9

        STRB W9, [X10, X8]      // Store the uppercase letter back into string[i]

        ADD X8, X8, 1           // Add 1 to X8 to keep it in the same address
        B loop                  // Restart loop

    end:
    LDR X30, [sp]           // Loads the original sp address that we're supposed to return to into X30
    ADD sp, sp, 8           // Deallocate stack 
    MOV X0, X8              // Move X8 into X0 so we can return it
    RET                     // Return it

_start:

    /* You code here:

        1. Call _toupper() to convert str;
        2. Call printf() to print outstr to show the result.
    */
    ADR X20, str             // Get the address of str and put it into X20 - Callee saved register
    // We won't have to reset this because this is the main function.

    MOV X0, X20              // Move address in X20 back into X0 as a parameter
    BL _toupper              // Call _toupper

    MOV X21, X0             // Stores the number of characters (returned from _toupper) into X21

    // Prepare to print
    ADR X0, outstr          // Put the address of outstr (to print) into X0
    MOV X1, X21             // Moves the number of characters converted into X1 as parameter
    MOV X2, X20             // Moves the address of str into X20
    BL printf               // Call printf

    MOV  X0, 0
    MOV  X8, 93
    SVC  0


.data
str:    .string   "helloworld"
outstr: .string   "Converted %ld characters: %s\n"
