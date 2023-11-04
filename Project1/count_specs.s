
/*  Name: Justin Chen
    Pledge: I pledge my honor that I have abided by the Stevens Honor System.
 */

.global count_specs

/**
    Counts the number of %a there are in the string
    Input parameters: X0 is a pointer to string

    This is a non-leaf register. Hence, we will only use temp registers and can ignore the stack points
 */
count_specs:
MOV W9, 37              // Move '%' into W9
MOV W10, 97             // Move 'a' into W10

MOV X11, 0              // Create a loop control variable for when we loop through the string
MOV X13, 0              // Use X13 to track whether or not we have seen a %. 
MOV X15, 0              // This counts the number of '%a' we see

_loop:
    LDRB W12, [X0, X11]     // Fetch str[i] into W12
    CBZ W12, _end_loop      // If we hit a null terminator, end the loop.

    CMP W12, W9             // If the item is %, we need to talk.
    B.EQ _ifpercent         //  Jump to if_percent

    B _end_ifpercent        // If not, ignore the loop

    _ifpercent:
        MOV X13, 1          // Set whether or not you've seen '%' to 1
        B _end_conditional  // Jump to end the conditional. We're done.
    _end_ifpercent:

    CMP W12, W10            // Compare str[i] to 'a'
    B.EQ _if_a              // If they're 'a', jump to _if_a

    B _end_if_a             // Otherwise, jump to the end of if (a)

    _if_a:
        CBZ X13, _end_if_a      // If the previous char is not '%', this 'a' is irrelevant. Jump to _end_if_a

        ADD X15, X15, 1         // Add 1 to X15
        MOV X13, 0              // Reset X13. We don't have a % now

        B _end_conditional      // Jump to end the else if conditional
    _end_if_a:

    // If we reach here, the char is neither '%' or 'a'. Hence, this does nothing.
    MOV X13, 0                  // Reset X13. If we had a '%', it's irrelevant now

    _end_conditional:
    ADD X11, X11, 1         // Add 1 to loop control variable
    B _loop                 // Reloop

_end_loop:

MOV X0, X15                 // Set the number of '%a' into the return argument
RET                         // Return the function

/*
    Declare .data here if you need.
*/
