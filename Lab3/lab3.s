//Justin Chen and Amartya Kalra
//I pledge my honor that I have abided by the Stevens Honor System
.text
.global _start

_start:
    ADR X0, dot         //Get the address of dot in X0
    ADR X1, vec1        //Adr of X1
    ADR X2, vec2        //Adr of X2
    LDR X5, [X0]        //Get the value of dot

    //Begin dot prod
    LDR X3, [X1]        //Get vec1[0]
    LDR X4, [X2]        //Get vec2[0]
    MUL X5, X3, X4      //Multiply X3 and X4, then store it to X5

    LDR X3, [X1, 8]     //Get vec1[1]
    LDR X4, [X2, 8]     //Get vec2[1]
    MUL X6, X3, X4      //Store X3 * X4 --> X6
    ADD X5, X6, X5      // X5 += X6

    LDR X3, [X1, 16]    //Get vec1[2]
    LDR X4, [X2, 16]    //Get vec2[2]
    MUL X6, X3, X4      //Store X3 * X4 --> X6
    ADD X5, X6, X5      // X5 += X6

    STR X5, [X0]        //Chuck stuff from X5 back into .dot

    //Exit
    MOV X0, 0           // X0 in MOV to signal SVC call
    MOV X8, 93          // 93 to shut down in X8
    SVC 0               // Execute System call

.data
    vec1: .quad 10, 20, 30
    vec2: .quad 1, 2, 3
    dot: .quad 0
