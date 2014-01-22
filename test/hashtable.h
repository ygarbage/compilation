#ifndef HASHTABLE_H
#define HASHTABLE_H

#include<stdlib.h>

typedef size_t hsize;

typedef struct hashtable_{
  hsize size;
  struct hash_node **nodes;
  int (*hashfunc)(const char*);
} hashtable;

struct hashnode{
  unsigned int *key;
  void * data;
  struct hashnode * next;
} ;

hashtable * htable_create(hsize size,hsize (*hashfunc)(const char*));
void htable_destroy(hashtable * h);
int htable_insert(hashtable *h,const int *key, void* data);
int htable_remove(hashtable* h, const int *key);
void* htable_get(hashtable* h, const int *key);

#endif
