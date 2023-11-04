/*  
   Name: Justin Chen
   Pledge: I pledge my honor that I have abided by the Stevens Honor System
*/

.global itoascii

/**
   This converts an integer into ASCII.
   The logic is that we find how many digits there are, create a number for 10^digits, and divide that way to isolate each digit
   Then, convert that digit into ASCII
 */
itoascii:
   //This is a non-leaf procedure. Hence, we don't need to allocate anything on the stack to store return address

   ADR X9, buffer          // Put string buffer address into X9. We'll need that later
   
   _continue:     // X15 and X16 are overwritable

   //⭐ As per calling convention, we should expect to get the integer to convert through X0 ⭐

   //🎩 Loop through and find the maximum place value of the number (ie. if a number is 3 digits, the max place value will be 100)
   MOV X15, X0             // Put X0 into X15 as a temporary backup so we don't actually divide X0
   MOV X16, 1              // Create a counter X16 to store the max place value. 
   MOV X17, 10             // Just putting 10 into X17 so we can multiply with it later
   //This is 10x more than needed, but don't worry we'll divide by 10 when this is done.

   _find_digits:
      CBZ X15, _end_find_digits                 // If X15 is equal to 0 (we divided all the place values), end the digit searching
      MUL X16, X16, X17             // X16 = X16 * 10
      UDIV X15, X15, X17            // Integer divide X15 by 10
      B _find_digits                // Continue recursing

   _end_find_digits:
   UDIV X16, X16, X17      // We put too much in X16 because we didn't want to divide by 0. To recover, divide place value by 10.
   MOV X13, 0              // Store 0 in X13. This will be used to track index of .buffer

   //🎩 Loop through all the place values and use that to isolate each digit. Then, convert that to ASCII
   //⭐ To convert an integer to ASCII, we add 48 ⭐
   _loop:
      UDIV X11, X0, X16       // Isolate the number by dividing X0 by the place value digit
      
      ADD X10, X11, 48         // Convert the item in X11 to ASCII, and store it in X10
      STRB W10, [X9, X13]       // Store converted item into buffer

      ADD X13, X13, 1          // Add 1 to X13 so buffer can be filled up
      MUL X14, X16, X11        // Multiply the place value and the isolated number. We will subtract X0 by this later
      SUB X0, X0, X14          // Subtract the number by the multiplied place value number to erase the digit

      UDIV X16, X16, X17       // Divide place value digit by 10 so we can continue isolate later
      
      CBNZ X16, _loop          // If we have not exhausted all place value, continue recursing

   // We know now X16 is zero
   STR X16, [X9, X13]      // Add null terminator to end of string just in case
   MOV X0, X9              // Prepare to return. Put the String buffer address into return argument X0
   RET                     // Return

   _returnNull:
   MOV X0, X9              // Put address of null buffer into X9
   RET                     // Return
.data
   /* Put the converted string into buffer,
      and return the address of buffer */
   buffer: .fill 128, 1, 0


