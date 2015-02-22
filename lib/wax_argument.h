//
//  wax_argument.h
//  
//
//  Created by Felipe Cavalcanti on 22/02/15.
//
//

#import <Foundation/Foundation.h>

typedef struct Argument
{
    struct Argument *next;
    void *data;
}Argument;

typedef struct Arguments
{
    struct Argument *first;
}Arguments;

void addArgument(Arguments *list, void* argument);
Arguments * NewArgumentList();
void freeArguments(Arguments * list);