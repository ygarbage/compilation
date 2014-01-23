#include <stdio.h>
#include <string.h>
#include <assert.h>

#include "variable.h"

int main(){
  Variable var;
  
  var_init(&var, "lol", "lolllvm", INT);
  assert (strcmp("lol", var_getName(&var)) == 0);
  assert (strcmp("lolllvm", var_getLLVMName(&var)) == 0);
  assert (var_isInt(&var) != 0);
  assert (var_isFloat(&var) == 0);
  assert (var_getType(&var) == INT);

  var_init(&var, "lol", "lolllvm", FLOAT);
  assert (var_isInt(&var) == 0);
  assert (var_isFloat(&var) != 0);
  assert (var_getType(&var) == FLOAT);
  
  var_setValue(&var, -131);
  assert (var_getValue(&var) == -131);

  var_setValue(&var, 1.234);
  assert (((var_getValue(&var)) - 1.234) < 0.00001);
  assert (var_getValue(&var) != 1);
      
  var_setType(&var, FLOAT);
  assert (var_isInt(&var) == 0);
  assert (var_isFloat(&var) != 0);
  assert (var_getType(&var) == FLOAT);

  var_setType(&var, INT);
  assert (var_isInt(&var) != 0);
  assert (var_isFloat(&var) == 0);
  assert (var_getType(&var) == INT);

  var_setAccess(&var, READONLY);
  assert (var_isWritable(&var) == 0);
  var_setAccess(&var, WRITABLE);
  assert (var_isWritable(&var) != 0);

  printf("Tests OK\n");
}
