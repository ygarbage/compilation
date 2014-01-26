#ifndef SPECIAL_H
#define SPECIAL_H

#include "hashtable.h"

#define SPECIAL_NB_VARIABLES 10
struct Special_types {
  char name[32];
  enum Type type;
};
  
struct Special_types special_variables_types[SPECIAL_NB_VARIABLES];

void special_init();
enum Type special_get_type(const char * name);
  
#endif /* SPECIAL_H */
