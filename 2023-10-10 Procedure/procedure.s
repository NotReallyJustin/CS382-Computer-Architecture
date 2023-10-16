.text
.global _start

//Declare procedure/function proc()
proc:
MOV x0, 0
MOV X1, 1
B _return        //Jump to return point

//If you want to start at a later point, you can just use _start label
//And assembly will jump to it
_start:
B proc          //Calling point

_return:
MOV X0, 9

B proc          //Call function again
.data