cat:
SUB sp, sp, 8           # Allocate stack    --> Remember addresses are 8 bytes
STR X30, [sp]           # Store the (return address + 4) of the previous thing that called cat (in X30) into stack

CMP X0, X1              # Compare x and y. If unstated, assume it's signed. Also, long int is by default signed
# Woah! You might want to `B.LT` directly, but you need to store the (current address + 4) into X30 so dog() or bunny() knows where to return to
# So... we'll make some more labels
B.LT call_dog
B call_bunny

call_dog:               # There we go! Now we handled conditional branching and calling bunny
BL dog
B continue

call_bunny:
BL bunny
B continue

continue:
LDR X30, [sp]           # Retrieve the previous return address that we're supposed to jump to into X30
ADD sp, sp, 8           # Deallocate stack
RET