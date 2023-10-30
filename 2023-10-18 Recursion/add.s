sum:
SUB sp, sp, 16               // Allocate memory in the stack for the stack pointer and for parameter X0
STR X30, [sp]               // Store X30 as per convention so we can return it later
STR X0, [sp, 8]

CMP X0, 1                   // If num == 1, that's our base case. We return 1
//We don't need to set return value X0 to 1 because it is already 1
B.EQ end
SUB X0, X0, 1               // num - 1          <--- Problem
BL sum
LDR X9, [sp, 8]             // Loads our initial num value (which is in sp + 8) into temp variable X9
ADD X0, X9, X0              // NOW, here we have num + sum(num - 1)
                            //                          ^^^         This is returned by sum in X0 in line 10

end:
LDR X30, [sp]               //Loads X30 back
ADD sp, sp, 16               //Deallocate memory
RET