#include "tools.h"

int tools_are_types_compatible(enum Type left, enum Type right) {
  if (left == REAL)
    return (right == REAL);
  else if (left == INTEGER)
    return (right == INTEGER);
  else if (left == REALPOINTER)
    return (right == REAL);
  else if (left == INTPOINTER)
    return (right == INTEGER);
  else ;
}


int htable_replace_llvm_name(struct hashtable * h,char * llvm_name, const char *key){
  struct Variable * var=(struct Variable *)htable_get(h,key);
  strcpy(var->llvm_name,llvm_name);  
  return !(strcmp(llvm_name,var->llvm_name));

}
