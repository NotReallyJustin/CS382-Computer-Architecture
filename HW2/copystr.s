/**
 * Name: Justin Chen
 * Pledge: I pledge my honor that I have abided by the Stevens Honor System
*/

.text
.global _start

_start:
ADR X18, src_str     // Get the memory address of the source string
ADR X19, dst_str     // Get the memory address of the destination string
MOV X8, 0            // Create a loop control variable that will end up iterating through copy_str

loop:
    LDRB W9, [X18, X8]  // Get char[i] and stores it in W9

    CMP W9, 0           // Check for null terminator
    B.EQ end            // If it's null terminator, go to the end

    //Else
    STRB W9, [X19, X8]  // Stores the character into the destination string[i]
    ADD X8, X8, 1       // Increment loop control variable
    B loop              // Jump to loop

end:
MOV W10, 0              // Stores null terminator into W10
STRB W10, [X19, X8]     // Stores null terminator in the end string
ADD X8, X8, 1           // Adds 1 to X8 to account for null terminators

//Now, let's print with system call
MOV X0, 1           //Setting value of X0 to 1 to get ready to print
ADR X1, dst_str     //Setting the address of dst_str into X1 to get ready to print
MOV X2, X8        //Moving length of dst_str into X2 to get ready to print. This is just the loop counter variable
MOV X8, 64          //Setting print command to X8
SVC 0               //Invoke syscall

//Terminate program code
MOV X0, 0        // Pass 0 to exit()
MOV X8, 93       // Move syscall number 93 (exit) to X8
SVC 0            // Invoke syscall

/*
 * If you need additional data,
 * declare a .data segment and add the data here
 */