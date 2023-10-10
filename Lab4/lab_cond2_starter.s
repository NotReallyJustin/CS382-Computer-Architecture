//Justin Chen & Amartya Kalra
//I pledge my honor that I have abided by the Stevens Honor System

.text
.global _start
.extern scanf

_start:
    
    ADR   X0, fmt_str   // Load address of formated string
    ADR   X1, left      // Load &left
    ADR   X2, right     // Load &right
    ADR   X3, target    // Load &target
    BL    scanf         // scanf("%ld %ld %ld", &left, &right, &target);

    ADR   X1, left      // Load &left
    LDR   X1, [X1]      // Store left in X1
    ADR   X2, right     // Load &right
    LDR   X2, [X2]      // Store right in X2
    ADR   X3, target    // Load &target
    LDR   X3, [X3]      // Store target in X3

    //Begin comparing - first compare if it's greater than right
    CMP X3, X2          //Compare target and right + sets condition codes
    B.LT _second_compare    //Jump to second_compare if target < right

    B _fail                 //Otherwise, we just fail

_second_compare:
    CMP X1, X3          //Compare left and target + sets condition codes
    B.LT _success       //If left < target, the we're good! Jump to success

    B _fail          //Otherwise we just fail

_fail:
    MOV X0, 1           //Setting value of X0 to 1 to get ready to print
    ADR X1, no         //Setting the address of no into X1 to get ready to print
    ADR X2, len_no      //Setting the address of len_no into X2 for later
    LDR X2, [X2]        //Storing len_no (length of no) into X2 to get ready for printing
    MOV X8, 64          //Setting print command to X8
    SVC 0               //Invoke syscall

    B exit              // Terminate program

_success:

    MOV X0, 1           //Setting value of X0 to 1 to get ready to print
    ADR X1, yes         //Setting the address of yes into X1 to get ready to print
    ADR X2, len_yes      //Setting the address of len_yes into X2 for later
    LDR X2, [X2]        //Storing len_yes (length of yes) into X2 to get ready for printing
    MOV X8, 64          //Setting print command to X8
    SVC 0               //Invoke syscall

    B exit              // Jump to Terminate Program

exit:
    MOV   X0, 0        // Pass 0 to exit()
    MOV   X8, 93       // Move syscall number 93 (exit) to X8
    SVC   0            // Invoke syscall

.data
    left:    .quad     0
    right:   .quad     0
    target:  .quad     0
    fmt_str: .string   "%ld%ld%ld"
    yes:     .string   "Target is in range\n"
    len_yes: .quad     . - yes  // Calculate the length of string yes
    no:      .string   "Target is not in range\n"
    len_no:  .quad     . - no   // Calculate the length of string no
