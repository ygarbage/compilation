#include"hashtable.h"

  int hash_table[101]; // varialbe initialisé à 0
  hsize def_hashfunc(const char * c){
    //TODO

    /* int n=0; */
    /* while(*c!='\0'){ */
    /*   n=n+8* *c ++; */
    /* } */
    /*   return n%101;     */
  }


hashtable * htable_create(hsize size, hsize (*hashfunc)(const char*) myhashfunc){
  hashtable *htable;
  if(!(htable=malloc(sizeof(hashtable)))) return NULL;

  if(!(htable->nodes=calloc(size,sizeof(struct hashnode*)))){
    free(htable);
    return NULL;
  }
  
  htable->size=size;
  if(hashfunc) htable->hashfunc= hashfunc;
  else htable->hashfunc=def_hashfunc;

  return htable;
}


void htable_destroy(hashtable *h){
  hsize n;

  hashnode *struct node, *oldnode;

  for(n=0;n<h->size;n++){
    node=h->nodes[n];
    while(node){
      free(node->key);
      //free(node->data);
      // the data should be created and destroy by the user's code
      oldnode=node;
      node=node->next;
      free(oldnode);
    }
  }
  free(h->nodes);
  free(h);
}

int htable_insert(hashtable *h,const int *key, void* data);
int htable_remove(hashtable* h, const int *key);
void* htable_get(hashtable* h, const int *key);
