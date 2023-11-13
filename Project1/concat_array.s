/*  
   Name: Justin Chen
   Pledge: I pledge my honor that I have abided by the Stevens Honor System
*/

.global concat_array

/**
   This converts an array into a set of readable strings. 
   Input: X0 = Array pointer
   X1 = Length of Array
   X19, X20, X21, X22, X23, 
*/
concat_array:
   SUB sp, sp, 56                    // Allocate 56 bytes for return address and the callee-saved registers

   STR X30, [sp]                    // Store the return address
   STR X19, [sp, 8]                 // Stores the callee saved address X19
   STR X20, [sp, 16]                // Stores callee saved address X20
   STR X21, [sp, 24]                // Stores callee saved address X21
   STR X22, [sp, 32]                // Stores callee saved address X22
   STR X23, [sp, 40]                // Stores callee saved address X23
   STR X24, [sp, 48]                // Stores callee saved address X24

   ADR X19, concat_array_outstr      // Get the address of concat_array_outstr
   MOV X20, X0                      // Move the array pointer to X20 because we might overwrite that later. 
                                    // X1 is fine bc itoascii uses 1 var

   // Step 1: Clean concat_array_outstr
   MOV X21, 0                        // Move 0 to X21 for the loop control variable
   MOV X22, 0                       // Make X22 zero (null in ASCII)

   _clean_array:
      CMP X21, 1024                  // If X21 == 1024 (size of concat_array_outstr), stop cleaning array
      B.EQ _continue                // Jump to continue

      STRB W10, [X19, X21]             // Stores 0 (null) inside that string index

      ADD X21, X21, 1                 // Increment loop counter (X21)
      B _clean_array                // Call clean_array again
   
   _continue:     // X19 and X21 are overwritable

   // Step 2: Loop through array
   MOV X21, 0                        // Make the loop counter (X21) zero again
   MOV X22, 0                       // Counter variable to track what "index" of concat_array_outstr we are at
   
   _loop_array:
      CMP X21, X1                    // Compare loop counter to array length
      B.EQ _end                     // If they're equal, jump to end and end this

      MOV X14, 8                       // Store 8 (size of long int) into X14
      MUL X15, X21, X14              // Get the current address size of the loop counter
      LDR X0, [X20, X15]             // Put the items in arr[i] into X0 to get ready to call itoascii <----

      BL itoascii                 // itoascii(arr[i]). This should return the pointer for the buffer in X0

      // X0 is now the pointer for buffer

      // Step 3: Transfer everything into concat_array_outstr
      MOV X23, 0                    // Create a loop counter for the X0 buffer inside X23

      _copystr:
         LDRB W24, [X0, X23]         // Put buffer[i] inside W24

         CMP W24, 0                  //Compare W24 and the null terminator
         B.EQ _end_copystr          // If W24 is a null terminator, end the loop and stop copying.

         STRB W24, [X19, X22]         // Store buffer[i] inside concat_array_outstr

         ADD X22, X22, 1            // Add 1 to X22 to denote that we increased 1 index in concat_array_outstr
         ADD X23, X23, 1            // Increment i for buffer
         B _copystr                 // Restart loop

      _end_copystr:
      MOV W13, 32                   // Move blank space char into X13
      STRB W13, [X19, X22]            // Put a space inside the concat_array_outstr
      ADD X22, X22, 1               // Add 1 to X22 to denote we increased 1 index in concat_array_outstr

      ADD X21, X21, 1                // Incrememnt X21 (loop control variable) to get next number
      B _loop_array                 // Call loop_array again

   _end:
   MOV W13, 0                       // Move null char into X13
   STRB W13, [X19, X22]              // Store null terminator

   MOV X0, X19                       // Move pointer of X19 into X0 (to return)

   LDR X30, [sp]                    // Retrieves the return address
   LDR X19, [sp, 8]                 // Retrieves the callee saved address X19
   LDR X20, [sp, 16]                // Retrieves callee saved address X20
   LDR X21, [sp, 24]                // Retrieves callee saved address X21
   LDR X22, [sp, 32]                // Retrieves callee saved address X22
   LDR X23, [sp, 40]                // Retrieves callee saved address X23
   LDR X24, [sp, 48]                // Retrieves callee saved address X24

   MOV X10, 0                        // Set X10 to 0

   LDR X10, [sp]                    // Cleans sp where X30 was at
   LDR X10, [sp, 8]                 // Cleans sp where X19 was at
   LDR X10, [sp, 16]                // Cleans sp where X20 was at
   LDR X10, [sp, 24]                // Cleans sp where X21 was at
   LDR X10, [sp, 32]                // Cleans sp where X22 was at
   LDR X10, [sp, 40]                // Cleans sp where X23 was at
   LDR X10, [sp, 48]                 // Cleans sp where X24 was at

   ADD sp, sp, 56                    // Deallocate
   RET                              // Return function

.data
    /* Put the converted string into concat_array_outstrer,
       and return the address of concat_array_outstr */
    concat_array_outstr:  .fill 1024, 1, 0

