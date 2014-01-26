#ifndef HASHTABLE_H
#define HASHTABLE_H

#include<stdlib.h>


/*
  La table de hashage est un tableau de listes chainées.
  Chaque élément possède une donnée est une clef. 
  La fonction de hashage permet à partir d'une clef d'obtenir
  l'indice du table où se trouve l'élément en question. 
  Il peut se trouver que deux éléments aient le même indice dans le tableau.
  Dans ce cas là ils forment une liste chainée à cet emplacement du tableau.

  La clef est un char * comme en td.

  Dans l'exemple de la fonction de hashage du TD en fait, la donnée 
  servait de clef. De plus la fonction renvoyait directement une valeur
  pouvant servir d'indice (ie comprise entre 0 et la taille du tableau).
  Ici par contre la fonction renvoie un entier qui doit encore passer
  modulo la taille du tableau pour être utilisé comme indice.
*/

typedef size_t hsize;

struct hashtable {
  hsize size;
  struct hashnode **nodes;
  hsize (*hashfunc)(const char*);
};

struct hashnode{
  char * key;
  void * data;
  struct hashnode * next;
};

/*
  La structure Variable permet de /TODO/
*/
struct Variable {
  //char flags; // Contains several informations : TODO|..|GLOBAL|WRITABLE|DECLARED
  enum Type { INTEGER, INTPOINTER, REAL, REALPOINTER,EMPTY, STRING, FUNCTION,OPERATOREQUAL,STRUCTURE }type;
  // the Comportement allows to make the difference between variable
  // and constant for writing an expression.
  enum Comportement {VAR,CST} cmpt;
  char * name;//char name[V_NAME_SIZE];
  char * llvm_name;
  // On n'utilise pas de #define pour la taille du code
  // car ceux ci ne sont pas reconnus (??)
  char code[2048];
  float value; // Store int in a float
};

struct hashtable * htable_create(hsize size,hsize (*hashfunc)(const char*));
void htable_destroy(struct hashtable * h);
int htable_insert(struct hashtable *h,const char * key, void* data);
void *htable_insert_type(struct hashtable* h, const char*key, enum Type type);
void *htable_insert_list(struct hashtable* h, enum Type type, char code[2048]);
int htable_remove(struct hashtable* h, const char * key);
void* htable_get(struct hashtable* h, const char *key);
int htable_resize(struct hashtable *h, hsize size);


#endif

/* struct Variable * var_left = malloc(sizeof(struct Variable)); */
/* struct Variable * var_right = malloc(sizeof(struct Variable)); */
/* var_left = (struct Variable *) htable_get(h, $1.name); */
/* var_right = (struct Variable *) htable_get(h, $3.name); */
    
/* /\* Debug *\/ */
/* printf("unary_expression name : %s\n", $1.name); */
/* printf("name : %s\n", var_left->name); */
/* printf("type : %d\n", var_left->type); */
/* printf("comparison_expression name : %s\n", $3.name); */
/* printf("name : %s\n", var_right->name); */
/* printf("type : %d\n", var_right->type); */
/* /\* Debug *\/ */
    
/* if (var_left->type != var_right->type) { */
/*   yyerror("Erreur : impossible d'affecter un %s dans un %s !\n", get_type_string(var_right->type), get_type_string(var_left->type)); */
/* } */
      
/* switch (var_left->type) { */
/* case REAL : */
/*   printf("%s = fadd %f, 0.0\n", var_left->llvm_name, $3.value); */
/*   break; */
/* default: */
/*   printf("default\n"); */
/* } */
