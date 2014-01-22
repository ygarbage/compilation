#include<stdlib.h>
#include<stdio.h>
#include<string.h>
#include"hashtable.h"
#include<assert.h>

hsize myhashfunc(const char * key){
  hsize hash=0;
  
  return hash;
}

int test_create__destroy(){
  hashtable* myhtable;
  hsize size=101;
  myhtable=htable_create(size,NULL);
  htable_destroy(myhtable);
  myhtable=NULL;
  return 1;
}

int test_add_element_and_find_it(){
  hashtable* myhtable;
  hsize size=101;
  myhtable=htable_create(size,NULL);
  htable_insert(myhtable,"Hugo","Yvaon");
  assert(!strcmp("Yvaon",htable_get(myhtable,"Hugo")));
  htable_destroy(myhtable);
  myhtable=NULL;  

  return 1;
}

int main(int argc, char* argv[]){
  
  if(test_create__destroy()) printf("OK\n");
  else printf("test create destroy failed");
  if(test_add_element_and_find_it()) printf("OK\n");
  else printf("test add element and find it failed");
  return EXIT_SUCCESS;
}
