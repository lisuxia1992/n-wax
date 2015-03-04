/*
 Copyright (c) 2015 Felipe Cavalcanti (felipejfc)
 See the file LICENSE for copying permission.
 */

#import "wax_argument.h"

void addArgument(Arguments *list, void* argument){
    if(list->first == NULL){
        list->first = (Argument *)malloc(sizeof(Argument));
        list->first->data = argument;
        list->first->next = NULL;
    }else{
        Argument* node = list->first;
        while(node->next != NULL){
            node = node->next;
        }
        node->next =(Argument *)malloc(sizeof(Argument));
        node->next->data = argument;
        node->next->next = NULL;
    }
}

Arguments * NewArgumentList(){
    Arguments * ret =(Arguments *)malloc(sizeof(Arguments));
    ret -> first = NULL;
    return ret;
}

void freeArguments(Arguments * list){
    Argument* node = list->first;
    while(node != NULL){
        Argument* tmp = node;
        node = node->next;
        free(tmp->data);
        free(tmp);
    }
    free(list);
}
