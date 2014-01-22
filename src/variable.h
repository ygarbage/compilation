#ifndef VARIABLE_H
#define VARIABLE_H

typedef enum Type_ { INT, FLOAT, STRING } Type;

typedef struct Variable_ {
  char flags; // Contient plusieurs champs : 
  // Type type;
} Variable;


int var_isInitialised();
int var_isGlobal();

#endif /* VARIABLE_H */
