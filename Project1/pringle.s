
/*  
    Name: Justin Chen
    Pledge: I pledge my honor that I have abided by the Stevens Honor System
 */

.global pringle

/**
    Printf, but for arrays
    We expect X0 - X7 to be parameters in the stack. Everything else goes on to the heap.
    The parameters come in string pointer, long int array pointer, length of array, long int array pointer, length of array...
 */
pringle:
//Step 1: Store all the parameters on to the stack so we can loop through them.
//For sake of convience, we will allocate 9*8 bytes (72 bytes) for X0 - X7 and sp. We can allocate the rest for callee-saved regs
//The rest should already have been on the stack.

SUB sp, sp, 144          // Allocate 72 bits

// Store callee-saved registers we used
STR X30, [sp]           // Stores sp
STR X19, [sp, 8]        // Stores X19 in the stack
STR X20, [sp, 16]        // Stores X20 in the stack
STR X21, [sp, 24]        // Stores X21 in the stack
STR X22, [sp, 32]        // Stores X20 in the stack
STR X23, [sp, 40]        // Stores X20 in the stack
STR X24, [sp, 48]        // Stores X20 in the stack
STR X25, [sp, 56]        // Stores X20 in the stack
STR X26, [sp, 64]        // Stores X20 in the stack
STR X27, [sp, 72]        // Stores X20 in the stack

// Stores the parameters
STR X0, [sp, 80]         // Stores X0 in the stack
STR X1, [sp, 88]        // Stores X1 in the stack
STR X2, [sp, 96]        // Stores X2 in the stack
STR X3, [sp, 104]        // Stores X3 in the stack
STR X4, [sp, 112]        // Stores X4 in the stack
STR X5, [sp, 120]        // Stores X5 in the stack
STR X6, [sp, 128]        // Stores X6 in the stack
STR X7, [sp, 136]        // Stores X7 in the stack

MOV X19, 0                     // Store the index of the pringle string we are at right now
ADR X20, return_buffer         // Store the address of the return_buffer into X20
MOV X21, 0                     // Stores the index of return_buffer we are at into X21
MOV X25, 88                     // Stores the index of the next "item" in the parameter list

MOV W22, 37              // Move '%' into W22
MOV W23, 97             // Move 'a' into W23
MOV X24, 0              // Create a variable X24 to track if we've seen a %.

MOV X26, 0              // Use X26 to track the number of characters we printed out

// Now, loop through the pringle string
_loop_pringle:
    LDR X12, [sp, 80]        // Fetch pointer to str and puts it in X12
    LDRB W27, [X12, X19]     // Fetch str[i] into W27 <--
    CBZ W27, _end_pringle   // If we hit a null terminator in pringle string, we're done with the function

    CMP W27, W22             // If the item is %, we need to talk.
    B.EQ _ifispercent         //  Jump to _ifispercent
    B _end_ifispercent        // If not, ignore the loop

    _ifispercent:
        //Edge case: if the previous item was also a %, print a '%' because it's not *the* '%'
        CBNZ X24, _extra_percent    // If X24 is 1, jump to _extra_percent
        B _end_extra_percent        // Else, skip the loop

        _extra_percent:

            STRB W22, [X20, X21]    // Store '%' into the return buffer

            ADD X21, X21, 1         // Increment 1 to the address offset of our current return buffer
            ADD X26, X26, 1         // Add 1 to X26 to denoted we printed 1 more char

        _end_extra_percent:

        MOV X24, 1          // Set whether or not you've seen '%' to 1
        B _end_the_conditional  // Jump to end the conditional. We're done.
    _end_ifispercent:

    CMP W27, W23            // Compare str[i] to 'a'
    B.EQ _if_have_a              // If they're 'a', jump to _if_a
    B _end_if_have_a             // Otherwise, jump to the end of if (a)

    _if_have_a:
        CBZ X24, _end_if_have_a      // If the previous char is not '%', this 'a' is irrelevant. Jump to _end_if_a

        LDR X0, [sp, X25]       // Loads the pointer to array in X0 to pass into concat_array later
        ADD X25, X25, 8         // Add 8 bytes to X25 to denote moving onto the next element in the stack
        LDR X1, [sp, X25]       // Loads the length of string in X1 to pass into concat_array later
        ADD X25, X25, 8         // Add 8 bytes to X25 to denote moving onto the next stack element

        BL concat_array         // Call concat array. The X0 now represents the pointer to the concat'd array

        // Put all items into the return buffer
        MOV X10, 0              // Create loop counter variable to loop through returned concat_array X0
        _chuck_item:
            LDRB W9, [X0, X10]  // Loads concat_array_output[i] into W9
            CBZ W9, _end_chuck_item     // if we hit a null terminator, we're done with the string

            //Else
            STRB W9, [X20, X21]          // Stores the character into an item in the return buffer.
            
            ADD X21, X21, 1         // Increment 1 to the address that our current return buffer is at
            ADD X10, X10, 1         // Incrememnt loop counter for returned concat_array X0
            ADD X26, X26, 1         // Add 1 to X26 to denote we "printed" out one more character

            B _chuck_item       // Jump to chuck_item again
        _end_chuck_item: 

        MOV X24, 0              // Reset X24. We don't have a % now

        B _end_the_conditional      // Jump to end the else if conditional

    _end_if_have_a:

    // If we reach here, the char is neither '%' or 'a'. Hence, this does nothing.
    CBNZ X24, _addpercent       // The '%' is irrelevant without the 'a'. Hence, we should print it out
    B _end_add_percent          // Otherwise, we don't need to add the percent

    _addpercent:
        MOV X24, 0              // X24 is now 0. We don't have a '%' anymore
        STRB W22, [X20, X21]    // Store '%' into the return buffer

        ADD X21, X21, 1         // Increment 1 to the address offset of our current return buffer
        ADD X26, X26, 1         // Add 1 to X26 to denoted we printed 1 more char

    _end_add_percent:
    STRB W27, [X20, X21]    // Store the char inside the string to return

    ADD X21, X21, 1         // Increment 1 to the address offset of our current return buffer
    ADD X26, X26, 1         // Add 1 to X26 to denoted we printed 1 more char

    _end_the_conditional:
    ADD X19, X19, 1         // Add 1 to loop control variable of pringle string
    B _loop_pringle                 // Reloop

    //If % at end, add %

_end_pringle:

//Edge case: If we end with a % flag still active, print that % because we're not going to ever accompany it with a 'a'
CBNZ X24, _end_percent      // Jump to _end_percent
B _genuine_end_pringle      // If not, jump to actual end

_end_percent:

    STRB W22, [X20, X21]    // Store '%' into the return buffer

    ADD X21, X21, 1         // Increment 1 to the address offset of our current return buffer
    ADD X26, X26, 1         // Add 1 to X26 to denoted we printed 1 more char

_genuine_end_pringle:
//Print out the string
MOV X0, 1           //Setting value of X0 to 1 to get ready to print
MOV X1, X20         //Setting the address of return_buffer into X1 to get ready to print
MOV X2, X26         //Storing len_yes (length of return_buffer) into X2 to get ready for printing
MOV X8, 64          //Setting print command to X8
SVC 0               //Invoke syscall

MOV X0, X26             // Move X26 into the stack to get ready to return it

// Retrieves Callee-Saved Registers we used
LDR X30, [sp]            // Retrieves sp
LDR X19, [sp, 8]         // Retrieves X19 in the stack
LDR X20, [sp, 16]        // Retrieves X20 in the stack
LDR X21, [sp, 24]        // Retrieves X21 in the stack
LDR X22, [sp, 32]        // Retrieves X20 in the stack
LDR X23, [sp, 40]        // Retrieves X20 in the stack
LDR X24, [sp, 48]        // Retrieves X20 in the stack
LDR X25, [sp, 56]        // Retrieves X20 in the stack
LDR X26, [sp, 64]        // Retrieves X20 in the stack
LDR X27, [sp, 72]        // Retrieves X20 in the stack

// Clean the stack that we allocated
MOV X9, 0

STR X9, [sp]             // Empties stack address that was sp
STR X9, [sp, 8]          // Empties stack address that was X19
STR X9, [sp, 16]         // Empties stack address that was X20
STR X9, [sp, 24]         // Empties stack address that was X21
STR X9, [sp, 32]         // Empties stack address that was X20
STR X9, [sp, 40]         // Empties stack address that was X20
STR X9, [sp, 48]         // Empties stack address that was X20
STR X9, [sp, 56]         // Empties stack address that was X20
STR X9, [sp, 64]         // Empties stack address that was X20
STR X9, [sp, 72]         // Empties stack address that was X20
STR X9, [sp, 80]         // Empties stack address that was X0
STR X9, [sp, 88]         // Empties stack address that was X1
STR X9, [sp, 96]         // Empties stack address that was X2
STR X9, [sp, 104]        // Empties stack address that was X3
STR X9, [sp, 112]        // Empties stack address that was X4
STR X9, [sp, 120]        // Empties stack address that was X5
STR X9, [sp, 128]        // Empties stack address that was X6
STR X9, [sp, 136]        // Empties stack address that was X7

ADD sp, sp, 144          // Deallocate stack
RET                     // Return the procedure

.data
   return_buffer: .fill 2048, 1, 0  // Stores the copied (or complete string) here so we can SVC it
