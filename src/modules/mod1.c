#include <stdio.h>

int isEven(int x)
{
    int evenInts[] = {0, 2, 4, 6, 8};
    int remainder = x % 10;
    for (int i = 0; i < 5; i++)
    {
        if (remainder == evenInts[i])
        {

            return 1;
        }
    }
    return 0;
}