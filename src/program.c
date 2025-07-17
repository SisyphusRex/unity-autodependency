#include "utils/math.h"

#include <stdio.h>

//
//
//  Bootstrap File
//
//

int isOdd(int x)
{
    int oddInts[] = {1, 3, 5, 7, 9};
    int remainder = x % 10;
    for (int i = 0; i < 5; i++)
    {
        if (remainder == oddInts[i])
        {

            return 1;
        }
    }
    return 0;
}

int run(int argc, char *args[])
{
    int x = 439;
    int oddCheck;

    oddCheck = isOdd(x);

    if (oddCheck == 1)
    {
        printf("%d is odd.\n", x);
    }
    else
    {
        printf("%d is even.\n", x);
    }

    int a = 1;
    int b = 2;
    int sum = addInts(a, b);

    return 0;
}