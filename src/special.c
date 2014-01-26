#include"special.h"

#include<string.h>

void special_init() {
  strcpy(special_variables_types[0].name, "%steerCmd");
  special_variables_types[0].type = REALPOINTER;
  strcpy(special_variables_types[1].name, "%accelCmd");
  special_variables_types[1].type = REALPOINTER;
  strcpy(special_variables_types[2].name, "%brakeCmd");
  special_variables_types[2].type = REALPOINTER;
  strcpy(special_variables_types[3].name, "%clutchCmd");
  special_variables_types[3].type = REALPOINTER;
  strcpy(special_variables_types[4].name, "%gearCmd");
  special_variables_types[4].type = INTPOINTER;
}

enum Type special_get_type(const char * name) {
  int i;
  for (i = 0; i < SPECIAL_NB_VARIABLES; ++i) {
    if ( strcmp(special_variables_types[i].name, name) == 0)
      return special_variables_types[i].type;
  }
  
  /* Default */
  return EMPTY;
}
