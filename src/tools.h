#ifndef TOOLS_H
#define TOOLS_H

#include "hashtable.h"

/* Returns 1 if t1 and t2 are compatible types for an affectation, 0 otherwise. */
int tools_are_types_compatible(enum Type left, enum Type right);
  
#endif /* TOOLS_H */
