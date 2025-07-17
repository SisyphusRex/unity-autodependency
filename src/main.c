#include "program.h"
#include <stdio.h>

//
//
//  Bootstrap File
//
//

int main(int argc, char *argv[])
{

    // Check if correct number of arguments provided
    /*
    int expectedArgs = 3;
    if (argc != 3) {
        printf("Incorrect number of arguments.  Expected %d", expectedArgs);
        return 1;
    }
    */

    // Remove program call from argv
    char *passedArgs[argc - 1];
    for (int i = 0; i < argc - 1; i++)
    {
        passedArgs[i] = argv[i + 1];
    }

    // run the program
    return run(argc - 1, passedArgs);
}