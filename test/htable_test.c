#include<stdlib.h>
#include<stdio.h>
#include<string.h>
#include"hashtable.h"


hsize myhashfunc(const char * key){


  return key;
}

int test_create__destroy(){
  hashtable* myhtable;
  hsize size=101;
  myhtable=htable_create(size,myhashfunc);


}


int main(int argc, char* argv[]){
  
  if(test_create__destroy()) printf("OK\n");
  else printf("test create destroy failed");
  return EXIT_SUCCESS;
}
