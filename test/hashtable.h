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

typedef struct hashtable_{
  hsize size;
  struct hashnode **nodes;
  hsize (*hashfunc)(const char*);
} hashtable;

struct hashnode{
  char * key;
  void * data;
  struct hashnode * next;
} ;

hashtable * htable_create(hsize size,hsize (*hashfunc)(const char*));
void htable_destroy(hashtable * h);
int htable_insert(hashtable *h,const char * key, void* data);
int htable_remove(hashtable* h, const char * key);
void* htable_get(hashtable* h, const char *key);
int htable_resize(hashtable *h, hsize size);

#endif
