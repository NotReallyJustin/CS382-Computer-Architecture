long int a = 4;

if (a == 0)
{
    a = 2;
}
else
{
    a = 4;
}

//Goto version
if (a == 0)
{
    goto Two;
}
else
{
    goto Four;
}

Two: a = 2;

//Add unconditional branching to skip a = 4, because we don't want that to execute.
goto End

Four: a = 4;

End: