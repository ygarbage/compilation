#include"hashtable.h"
#include<string.h>
#include<stdio.h>

hsize def_hashfunc(const char * key){
  hsize hash=0;
  while(*key!='\0'){
    hash+= *key+8* (unsigned char)*key;
    (unsigned char) *key++;
  }
  return hash;
}


struct hashtable * htable_create(hsize size, hsize (*hashfunc)(const char*)){
  struct hashtable *htable;
  if(!(htable=malloc(sizeof(struct hashtable)))) return NULL;

  if(!(htable->nodes=calloc(size,sizeof(struct hashnode*)))){
    free(htable);
    return NULL;
  }
  
  htable->size=size;
  if(hashfunc) htable->hashfunc= hashfunc;
  else htable->hashfunc=def_hashfunc;

  return htable;
}


void htable_destroy(struct hashtable *h){
  hsize n;

  struct hashnode * node, *oldnode;

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

int htable_insert(struct hashtable *h, const char *key, void* data){
  struct hashnode *node;
  hsize hash=h->hashfunc(key)%h->size;
  
  node=h->nodes[hash];

  while(node){
    /*
      On cherche un noeud qui possède la même clef
      ie le même noeud et on le met à jour.
    */
    if(!(strcmp(node->key,key))){
      // mise à jour
      node->data=data;
      return 0;
    }    
    node=node->next;
  }
  /*
    Sinon on crée un nouveau noeud qu'on insert au début de la liste chainée.
  */
  if(!(node=malloc(sizeof(struct hashnode)))) return -1;
  if(!(node->key=strdup(key))){
    free(node);
    return -1;
  }
  node->data=data;
  node->next=h->nodes[hash];
  h->nodes[hash]=node;
  return 0;
}
int htable_remove(struct hashtable* h, const char *key){
  struct hashnode *node,*prevnode=NULL;
  hsize hash=h->hashfunc(key)%h->size;
  node=h->nodes[hash];
  while(node){
    if(!strcmp(node->key,key)){
      free(node->key);
      if(NULL==prevnode) h->nodes[hash]=node->next;
      else prevnode->next=node->next;
      free(node);
      return 0;
    }
    prevnode=node;
    node=node->next;
  }
  perror("htable_remove() : element not found");
  return -1;
}

void* htable_get(struct hashtable* h, const char *key){
  struct hashnode* node;
  hsize hash=h->hashfunc(key)%h->size;
  node=h->nodes[hash];
  while(node){
    if(!strcmp(node->key,key)) return node->data;
    node=node->next;
  }
  return NULL;
}

int htable_resize(struct hashtable *h, hsize size){
  struct hashtable newtbl;
  hsize n;
  struct hashnode *node;

  newtbl.size=size;
  newtbl.hashfunc=h->hashfunc;

  if(!(newtbl.nodes=calloc(size, sizeof(struct hashnode*)))) return -1;

  for(n=0; n<h->size; ++n) {
    for(node=h->nodes[n]; node; node=node->next) {
      htable_insert(&newtbl, node->key, node->data);
      htable_remove(h, node->key);
			
    }
  }

  free(h->nodes);
  h->size=newtbl.size;
  h->nodes=newtbl.nodes;

  return 0;
}
