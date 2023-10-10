.text
ADD X0, X0, 1           // 0x1000
B L1                    // 0x1004
SUB X0, X0, 2           // 0x1008
L1: STR X0, [X9]        // 0x100C