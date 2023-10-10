//Justin Chen & Amartya Kalra
//I pledge my honor that I have abided by the Stevens Honor System

.text
.global _start

_start:
    ADR X1, side_a     //Store side_a address into X1
    ADR X2, side_b       //Store side_b address into X2
    ADR X3, side_c       //Store side_c address into X3

    //Find a^2
    LDR X4, [X1]         //Stores side_a into X4
    MUL X4, X4, X4      //Calculate a^2 and store it into X4

    //Find b^2
    LDR X5, [X2]        //Stores side_b into X5
    MUL X5, X5, X5      //Calculates b^2 and store it into X5

    ADD X4, X4, X5      // Calculates a^2 + b^2 and stores it into X4

    //Find c^2
    LDR X5, [X3]        //Stores side_c into X5
    MUL X5, X5, X5      //Calculates c^2 and stores it into X5

    //Compares and branches
    CMP X4, X5          //Compares X5 and X4 and sets condition codes
    B.EQ _equal         //Jump to _equal if they're equal

    B _notequal         //Else jump to _notequal

    
_equal:

    MOV X0, 1           //Setting value of X0 to 1 to get ready to print
    ADR X1, yes         //Setting the address of yes into X1 to get ready to print
    ADR X2, len_yes    //Setting the address of len_yes into X2 for later
    LDR X2, [X2]        //Storing len_yes (length of yes) into X2 to get ready for printing
    MOV X8, 64          //Setting print command to X8
    SVC 0               //Invoke syscall

    B _exit             //End program
    
_notequal:

    MOV X0, 1           //Setting value of X0 to 1 to get ready to print
    ADR X1, no         //Setting the address of no into X1 to get ready to print
    ADR X2, len_no    //Setting the address of len_no into X2 for later
    LDR X2, [X2]        //Storing len_yes (length of no) into X2 to get ready for printing
    MOV X8, 64          //Setting print command to X8
    SVC 0               //Invoke syscall

    B _exit             //End program

_exit:
    MOV   X0, 0        // Pass 0 to exit()
    MOV   X8, 93       // Move syscall number 93 (exit) to X8
    SVC   0            // Invoke syscall

.data
    side_a: .quad 3
    side_b: .quad 4
    side_c: .quad 5
    yes: .string "It is a right triangle.\n"
    len_yes: .quad . - yes // Calculate the length of string yes
    no: .string "It is not a right triangle.\n"
    len_no: .quad . - no // Calculate the length of string no
