#include<stdlib.h>
#include<stdio.h>
#include<string.h>
#include"hashtable.h"


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


int main(int argc, char* argv[]){
  
  if(test_create__destroy()) printf("OK\n");
  else printf("test create destroy failed");
  return EXIT_SUCCESS;
}
