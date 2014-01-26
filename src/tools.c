#include "tools.h"

int tools_are_types_compatible(enum Type left, enum Type right) {
  if (left == REAL)
    return (right == REAL);
  else if (left == INTEGER)
    return (right == INTEGER);
  else if (left == REALPOINTER)
    return (right == REAL);
  else if (left == INTPOINTER)
    return (right == INTEGER);
  else ;
}
