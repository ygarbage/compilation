#include"hashtable.h"

  hsize def_hashfunc(const char * key){
    hsize hash=0;
    while(*key!='\0') hash+= n+8* (unsigned char)*key++;
    return hash;
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

int htable_insert(hashtable *h, const char *key, void* data){
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
  if(!node=malloc(sizeof(struct hashnode))) return -1;
  if(!node->key=strdup(key)){
    free(node);
    return -1
  }
  node->data=data;
  node->next=h->nodes[hash];
  h->node[hash]=node;
  return 0;
}
int htable_remove(hashtable* h, const const char *key);
void* htable_get(hashtable* h, const const char *key);
