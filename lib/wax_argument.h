/*
 Copyright (c) 2015 Felipe Cavalcanti (felipejfc)
 See the file LICENSE for copying permission.
 */

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