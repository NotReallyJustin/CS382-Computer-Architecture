/*
Author: Amartya Kalra & Justin Chen
Assignment: CS382 - Lab 2
Date: September 19 2023
Pledge: I pledge my honor that I have abided by the Stevens Honor System.
*/

.text
.global _start

_start:
    MOV X0, 1       /*Set destination X0 to 1 for printing*/
    MOV X8, 64      /*Set system call number to be 64*/

    ADR X1, msg     /* Loads RAM address of msg into X1 */
    
    ADR X3, length  /* Loads RAM address of length of X3 */
    LDR X2, [X3]    /* Fetches the value stored the RAM Address in X3, and move it to X2 */

    SVC 0           /* System call to print out */

    /* Start shutting down program */
    MOV X0, 0       /* Sets destination X0 in registry to 0 for shut down */
    MOV X8, 93      /* Set system call number to 93 */
    SVC 0           /* System call to officially shut down */

.data
    msg: .string "Hello World!\n"       /* The hello world text */
    length: .quad . - msg               /* Find length of message */
    