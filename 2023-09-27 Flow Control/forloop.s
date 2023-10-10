.text
.global _start

# Get address of msg and len and their values first
ADR x0 len
ADR X1 msg
LDR X2, [X0]     # Store len here
LDRB X3, [X1]     # Store msg[0] here

# For loop
MOV X4 1        # The 1 to increment by in loop

Loop:
CBZ W1, End         # Jump to null when we see \0
ADD X2, X2, X4      # X2 += 1
LDRB W1, [X0, X2]   # Get next msg char
B loop              # Restart End

End:
STR X2, [X0]        # Store it back to RAM

.data
msg: .string "hello"
len: .quad 0