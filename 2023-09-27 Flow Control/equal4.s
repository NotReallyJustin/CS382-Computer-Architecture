.text
.global _start

# Find the address of a
ADR X19 a
LDR X0 [X19]

.data
a: .int 4