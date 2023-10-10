int S(n)
{
    int sum = 0;

    for (int i = 1; i <= n; i++)
    {
        if (i == 1)
        {
            sum += 1;
        }
        else
        {
            sum += i * i * i;
        }
    }
}