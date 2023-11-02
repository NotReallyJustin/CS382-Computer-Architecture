/**
 * Name: Justin Chen
 * Pledge: I pledge my honor that I have abided by the Stevens Honor System
*/

.text
.global _start

_start:
ADR X19, arr        // Load the address of the arr into X19
ADR X20, length     // Loads the address of the length variable into X20
LDR X20, [X20]      // Puts the length of arr into X20
ADR X21, target     // Puts the address of our target item into X21
LDR X21, [X21]      // Puts our target item into X21

//Begin binary search
MOV X9, 0           // Sets the left to beginning of string (X9)

MOV X10, X20        // Sets the length of arr into X10 (the right)
SUB X10, X10, 1     // Sets it to X10 - 1 for bounds

loop:
CMP X9, X10         // Compares the left and the right
B.GT _unfound       // If left > right, we didn't find anything. Jump to unfound

ADD X11, X9, X10    // Adds X9 and X10 and stores it in X11 (X11 represent the middle)
ASR X11, X11, 1     // Arithmetic shift right middle register by 1 to divide it by 2
MOV X8, 8           // Set X8 to 8
MUL X13, X11, X8    // Multiply our index by 8 in order to get the assembly idx
LDR X12, [X19, X13] // Loads the item in the middle index of the array into X12

CMP X12, X21        // Compares the middle item to the target item
B.LT smaller        // If it's smaller, jump to smaller
B.EQ _found         // If it's equal, yipee! We found the item
B.GT greater        // If it's greater than, jump to greater

smaller:
ADD X11, X11, 1     // Do middle + 1
MOV X9, X11         // Sets the left idx to the middle + 1
B loop              // Go back to reloop

greater:
SUB X11, X11, 1     // Do middle - 1
MOV X10, X11        // Sets the right idx to the middle - 1
B loop              // Go to reloop

_found:
MOV X0, 1           //Setting value of X0 to 1 to get ready to print
ADR X1, msg1        // Load address of msg1 into X1 to get ready to print
MOV X2, 25          // Setting length of msg1 into X2 to get ready to print
MOV X8, 64          //Setting print command to X8
SVC 0               //Invoke syscall
B _end

_unfound:
MOV X0, 1           //Setting value of X0 to 1 to get ready to print
ADR X1, msg2        // Loads address of msg2 into X1 to get ready to print
MOV X2, 29          // Setting length of msg2 into X2 to get ready to print
MOV X8, 64          //Setting print command to X8
SVC 0               //Invoke syscall
B _end

_end:
//Terminate program code
MOV X0, 0        // Pass 0 to exit()
MOV X8, 93       // Move syscall number 93 (exit) to X8
SVC 0            // Invoke syscall

/*
 * If you need additional data,
 * declare a .data segment and add the data here
 */