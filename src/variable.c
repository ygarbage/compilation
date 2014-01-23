#include "variable.h"

#include <string.h>

/* Getters */

/* Returns 1 if the variable is declared, 0 otherwise */
int var_isDeclared(const Variable * v) {
  return (v->flags & V_DECLARED);
}

/* Returns 1 if the variable is writable, 0 otherwise */
int var_isWritable(const Variable * v) {
  return (v->flags & V_WRITABLE);
}

/* Returns 1 if the variable is global, 0 otherwise */
int var_isGlobal(const Variable * v) {
  return (v->flags & V_GLOBAL);
}

/* Returns 1 if the variable is a function, 0 otherwise */
int var_isFunction(const Variable * v) {
  return v->type == FUNCTION;
}

/* Returns 1 if the variable is an integer, 0 otherwise */
int var_isInt(const Variable * v) {
  return v->type == INT;
}

/* Returns 1 if the variable is a float, 0 otherwise */
int var_isFloat(const Variable * v) {
  return v->type == FLOAT;
}

/* Returns the variable type */
Type var_getType(const Variable * v) {
  return v->type;
}

/* Returns the variable value */
float var_getValue(const Variable * v) {
  return v->value;
}

/* Returns the variable name */
const char * var_getName(const Variable * v) {
  return v->name;
}

/* Returns the variable llvm name */
const char * var_getLLVMName(const Variable * v) {
  return v->llvm_name;
}


/* Setters */

/* Initialize a variable with its name, llvm name, and type */
void var_init(Variable * v, const char * name, const char* llvm_name, Type t) {
  v->type = t;
  strcpy(v->name, name);
  strcpy(v->llvm_name, llvm_name);
  v->value = 0;
  v->flags = V_DECLARED | V_WRITABLE ;
}

/* Set variable value */
void var_setValue(Variable * v, float val) {
  v->value = val;
}

/* Set variable type */
void var_setType(Variable * v, Type t) {
  v->type = t;
}

/* Set write access (writable or not) */
void var_setAccess(Variable * v, Access writable_flag) {
  if (writable_flag == READONLY) {
    v->flags &= ~(V_WRITABLE);
  }
  else {
    v->flags |= V_WRITABLE;
  }
}

