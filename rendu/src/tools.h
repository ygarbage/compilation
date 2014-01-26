#ifndef TOOLS_H
#define TOOLS_H

#include "hashtable.h"
#include <string.h>
/* Returns 1 if t1 and t2 are compatible types for an affectation, 0 otherwise. */
int tools_are_types_compatible(enum Type left, enum Type right);
int htable_replace_llvm_name(struct hashtable * h,char * llvm_name, const char *key);
  
#endif /* TOOLS_H */
