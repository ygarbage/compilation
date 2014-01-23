#ifndef VARIABLE_H
#define VARIABLE_H

#define V_NAME_SIZE 32
#define V_LLVMNAME_SIZE 32

#define V_NULL     0x0
#define V_DECLARED 0x1
#define V_WRITABLE 0x2
#define V_GLOBAL   0x4

typedef enum Type_ { INTEGER, REAL, EMPTY, STRING, FUNCTION } Type;
typedef enum Access_ { READONLY = 0, WRITABLE = 1} Access;

struct Variable {
  char flags; // Contains several informations : TODO|..|GLOBAL|WRITABLE|DECLARED
  Type type;
  char name[V_NAME_SIZE];
  char llvm_name[V_LLVMNAME_SIZE];
  float value; // Store int in a float
} Variable;

/* Getters */

/* Returns 1 if the variable is declared, 0 otherwise */
int var_isDeclared(const struct Variable *);

/* Returns 1 if the variable is writable, 0 otherwise */
int var_isWritable(const struct Variable *);

/* Returns 1 if the variable is global, 0 otherwise */
int var_isGlobal(const struct Variable *);

/* Returns 1 if the variable is a function, 0 otherwise */
int var_isFunction(const struct Variable *);

/* Returns 1 if the variable is an integer, 0 otherwise */
int var_isInt(const struct Variable *);

/* Returns 1 if the variable is a float, 0 otherwise */
int var_isFloat(const struct Variable *);

/* Returns the variable type */
Type var_getType(const struct Variable *);

/* Returns the variable value */
float var_getValue(const struct Variable *);

/* Returns the variable name */
const char * var_getName(const struct Variable *);

/* Returns the variable llvm name */
const char * var_getLLVMName(const struct Variable *);


/* Setters */

/* Initialize a variable with its name, llvm name, and type */
void var_init(struct Variable*, const char*, const char*, Type);

/* Set variable value */
void var_setValue(struct Variable*, float);

/* Set variable type */
void var_setType(struct Variable*, Type);

/* Set write access (writable or not) */
void var_setAccess(struct Variable*, Access);

#endif /* VARIABLE_H */
