#ifndef EXISTING_FUNCTION_H
#define EXISTING_FUNCTION_H

#include <stdlib.h>
#include "hashtable.h"
#include <string.h>

#define FUNCTION_NAME_SIZE 50

char * printDriveTop(struct hashtable* h);
char * global_functions();
void addGlobalFunctionHtable(struct hashtable * h, char * name_arg, char * params);


#endif
