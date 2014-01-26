%{
#include <stdio.h>
#include <string.h>

//#include "static.h"
#include "existing_function.h"
#include "hashtable.h"
#include "special.h"
  extern int yylineno;
  int yylex ();
  int yyerror ();

  //debug
  int i=0;

  struct hashtable * h = NULL;
  char tmpnumber[20];
  unsigned int reg=0;


char *get_type_string(enum Type t){
  switch(t){
  case(REAL):
    return "float ";
    break;
  case(EMPTY):
    return "void ";
    break;
  default:
    return NULL;

  }
}


  %}

%union {
  /*
   * Cette variable 'code' est le type de ce que contient : expression, 
   * type_name,statement, compound_statement, expression_statement, 
   * statement_list.
   * En effet par ces champs on ne fait que remonter du code le long de 
   * l'arbre syntaxique.
   */
  char code[2048];
  struct Variable var;
  enum Type type;
}

%token <var> IDENTIFIER
%token <var> CONSTANTF
%token <var> CONSTANTI

%token INC_OP DEC_OP LE_OP GE_OP EQ_OP NE_OP
%token <var> SUB_ASSIGN MUL_ASSIGN ADD_ASSIGN
%token TYPE_NAME
%token INT
%token FLOAT
%token VOID

%type <var> declarator primary_expression postfix_expression unary_expression multiplicative_expression additive_expression comparison_expression
%type <var> assignment_operator
%type <code> expression
%type <type> type_name 
%type <code> statement compound_statement expression_statement statement_list
%type <code> declaration_list declaration declarator_list

%token IF ELSE WHILE RETURN FOR

%start program
%%

primary_expression
: IDENTIFIER {
  //copy of the type of the identifier in a tampon only if
  //the element already exists in the htable.
  //In order to not overwrite it with nothing, losing information.
  if (NULL != htable_get(h,$1.name) ) {
    enum Type t = ((struct Variable *)htable_get(h,$1.name))->type; 
    $$.type = t;
    printf("TYPE = %d \n",t);
  }

  //copy of var name from ID to primary expression
  strcpy($$.name,$1.name);
  //creation of llvm_name from ID to primary expression
  $$.llvm_name = malloc(strlen($1.name + 10) * sizeof(char));

  if ( $1.name[0] == '$') { // Special variable
    printf("SPECIAL variable !\n");
    if ( strstr($1.name, "Cmd") != NULL) { // If it already contains Cmd
      sprintf($$.llvm_name,"%%%s", ($1.name+1));
      printf("name : %s\n", $$.llvm_name);
    }
    else { // Else, adding Cmd is necessary
      sprintf($$.llvm_name,"%%%sCmd", ($1.name+1));
      printf("name : %s\n", $$.llvm_name);
    }
    // Debug : printf("type : %d\n", special_get_type($$.llvm_name));
    $$.type = special_get_type($$.llvm_name);
  }

  else{ // Regular variable
    printf("REGULAR variable !\n");
    sprintf($$.llvm_name,"%%%s%d", $1.name,reg++);
    printf("name : %s\n", $$.llvm_name);
  }
  // Here it's a variable that goes in the htable
  $$.cmpt = VAR;
  // The value is in the htable. key==name (NOT LLVM NAME)
  htable_insert(h, $$.name, (void*) &$$);
  printf("LLVM NAME %s !!! n°%d\n",$$.llvm_name,i++);
 }
| CONSTANTI {$$.value = $1.value; $$.cmpt=CST;}
| CONSTANTF {$$.value = $1.value; $$.cmpt=CST;}
| '(' expression ')' {
  strcpy($$.code,"(");
  strcat($$.code,$2);
  /*Peut etre source de BOG
    car concaténation.
  */
  strcat($$.code,")");
  }
| IDENTIFIER '(' ')' {
  }
| IDENTIFIER '(' argument_expression_list ')' {}
| IDENTIFIER INC_OP {}
| IDENTIFIER DEC_OP {}
;

postfix_expression
: primary_expression {
  if($1.cmpt==CST){
    //copy of value
    $$.value=$1.value;
    printf("postfix exp Value %f !!! n°%d\n",$$.value,i++);
  }
  else{
    //copy of llvm_name
    $$.llvm_name=$1.llvm_name;
    //copy of name
    $$.name=$1.name;
    printf("postfix expression LLVM NAME %s !!! n°%d\n",$$.llvm_name,i++);  
  }
 }
| postfix_expression '[' expression ']'
;

argument_expression_list
: expression
| argument_expression_list ',' expression
;

unary_expression
: postfix_expression{
  if($1.cmpt==CST){
    //copy of value
    $$.value=$1.value;
    printf("postfix exp Value %f !!! n°%d\n",$$.value,i++);
  }
  else{
    //copy of llvm_name
    $$.llvm_name=$1.llvm_name;
    //copy of name
    $$.name=$1.name;
    printf("postfix expression LLVM NAME %s !!! n°%d\n",$$.llvm_name,i++);  
  }
 }
| INC_OP unary_expression {$$ = $2;}
| DEC_OP unary_expression {$$ = $2;}
| unary_operator unary_expression {$$ = $2;}
;

unary_operator
: '-'
;

multiplicative_expression
: unary_expression{
  if($1.cmpt==CST){
    //copy of value
    $$.value=$1.value;
    printf("postfix exp Value %f !!! n°%d\n",$$.value,i++);
  }
  else{
    //copy of llvm_name
    $$.llvm_name=$1.llvm_name;
    //copy of name
    $$.name=$1.name;
    printf("postfix expression LLVM NAME %s !!! n°%d\n",$$.llvm_name,i++);  }
 }
| multiplicative_expression '*' unary_expression
| multiplicative_expression '/' unary_expression
;

additive_expression
: multiplicative_expression{
  if($1.cmpt==CST){
    //copy of value
    $$.value=$1.value;
    printf("postfix exp Value %f !!! n°%d\n",$$.value,i++);
  }
  else{
    //copy of llvm_name
    $$.llvm_name=$1.llvm_name;
    //copy of name
    $$.name=$1.name;
    printf("postfix expression LLVM NAME %s !!! n°%d\n",$$.llvm_name,i++);  
  }
 }
| additive_expression '+' multiplicative_expression
| additive_expression '-' multiplicative_expression
;

comparison_expression
: additive_expression{
  if($1.cmpt==CST){
    //copy of value
    $$.value=$1.value;
  }
  else{
    //copy of llvm_name
    $$.llvm_name=$1.llvm_name;
    //copy of name
    $$.name=$1.name;
    printf("postfix expression LLVM NAME %s !!! n°%d\n",$$.llvm_name,i++);  
  }
 } 
| additive_expression '<' additive_expression
| additive_expression '>' additive_expression
| additive_expression LE_OP additive_expression
| additive_expression GE_OP additive_expression
| additive_expression EQ_OP additive_expression
| additive_expression NE_OP additive_expression
;

expression
: unary_expression assignment_operator comparison_expression  {
  strcpy($$,""); // avoid print bug
  if ($2.type == OPERATOREQUAL) { // If it is an affectation
    //debug
    if(((struct Variable *)htable_get(h,$1.name))->type
       != ((struct Variable *)htable_get(h,$3.name))->type){
      yyerror("Erreur de type");
    }
    
    else{
      //struct Variable * var_right=malloc(sizeof(struct Variable));
      //var_right=htable_get(h,$3.name);
      
      strcat($$,$1.llvm_name);
      if($3.cmpt==VAR){
	switch($1.type){
	case(REAL):
	  strcat($$," = fadd float 0.0, ");
	  strcat($$,$3.llvm_name);
	  break;
	case(INTEGER):
	  sprintf(tmpnumber,"%d",(int)$3.value);
	  strcat($$," = add i32 0, ");
	  strcat($$,tmpnumber);
	  break;
	case(REALPOINTER):
	  sprintf($$,"float* %s\n",$1.llvm_name);
	  break;
	case(INTPOINTER):
	  sprintf($$,"i32* %s\n",$1.llvm_name);
	  break;
	default:
	  perror("DEFAULT var");
	}
      }
      else{
	switch($1.type){
	case(REAL):
	  sprintf(tmpnumber,"%f",$3.value);
	  strcat($$," = fadd float 0.0, ");
	  strcat($$,tmpnumber);
	  break;
	case(INTEGER):
	  sprintf(tmpnumber,"%d",(int)$3.value);
	  strcat($$," = add i32 0, ");
	  strcat($$,tmpnumber);
	  break;
	case(REALPOINTER):
	  sprintf($$,"float* %s\n",$1.llvm_name);
	  break;
	case(INTPOINTER):
	  sprintf($$,"i32* %s\n",$1.llvm_name);
	  break;
	default:
	  perror("DEFAULT cst");
	}
      }
    }
  }
 }

| comparison_expression
;

assignment_operator
: '='{$$.type=OPERATOREQUAL;}
| MUL_ASSIGN
| ADD_ASSIGN
| SUB_ASSIGN
;

declaration
: type_name declarator_list ';' {
  strcat($2,";");
  htable_insert_list(h,$1,$2);
  //Avoid a print bog :
  strcpy($$,"");
  
 }
;

declarator_list
: declarator {strcpy($$,$1.name);}
| declarator_list ',' declarator{strcat($1,",");strcat($1,$3.name);strcpy($$,$1);}
;

type_name
: VOID{$$=EMPTY;}
| INT{$$=INTEGER;}   
| FLOAT{$$=REAL;}
;

declarator
: IDENTIFIER {
  $$.name= $1.name;
  htable_insert(h,$1.name,(void *)&$1);
 }
| '(' declarator ')'{
  $$.name = strdup($2.name);
  sprintf($$.code,"(%s)",$$.name); 
  }
| declarator '[' CONSTANTI ']'
| declarator '[' ']'
| declarator '(' parameter_list ')' {}
| declarator '(' ')' {
   strcpy($$.name,$1.name); 
  if(strcmp($$.name,"drive")==0){
    //printf("");
    strcpy($$.code,"");
    sprintf($$.code,"@%s (i32 %%index, %%struct.CarElt* %%car, %%struct.SItuation* %%s)",$$.name);
  }
  }
;

parameter_list
: parameter_declaration
| parameter_list ',' parameter_declaration
;

parameter_declaration
: type_name declarator
;

statement
: compound_statement
| expression_statement{strcpy($$,"");strcpy($$,$1);} 
| selection_statement
| iteration_statement
| jump_statement
;

compound_statement
: '{' '}'
| '{' statement_list '}'{strcpy($$,"");strcpy($$,$2); }
| '{' declaration_list statement_list '}' {strcpy($$,"");strcat($2,$3); strcpy($$,$2);}
;

declaration_list
: declaration {//strcpy($$,$1);
  strcpy($$,"declaration list \n");
strcpy($$,"");  strcat($$,$1);
 }
| declaration_list declaration
;

statement_list
: statement{strcpy($$,$1);}
| statement_list statement{strcpy($$,"");strcat($1,$2);strcpy($$,$1);}
;

expression_statement
: ';'
| expression ';'{strcpy($$,$1);strcat($$,"\n");}
;

selection_statement
: IF '(' expression ')' statement
| IF '(' expression ')' statement ELSE statement
| FOR '(' expression_statement expression_statement expression ')' statement
;

iteration_statement
: WHILE '(' expression ')' statement
;

jump_statement
: RETURN ';'
| RETURN expression ';'
;

program
: external_declaration
| program external_declaration
;

external_declaration
: function_definition
| declaration
;

function_definition
: type_name declarator compound_statement{printf("define %s",get_type_string($1)); printf("%s ",$2.code); printf("{\n %s \n}\n"/* ,printDriveTop(h) */,$3);}
;

%%
#include <stdio.h>
#include <string.h>

extern int column;
extern int yylineno;
extern FILE *yyin;

char *file_name = NULL;

int yyerror (char *s) {
  fflush (stdout);
  fprintf (stderr, "%s:%d:%d: %s\n", file_name, yylineno, column, s);
  return 0;
}


int main (int argc, char *argv[]) {
  FILE *input = NULL;
  if (argc == 2) {
    input = fopen (argv[1], "r");
    file_name = strdup (argv[1]);
    if (input) {
      yyin = input;
    }
    else {
      fprintf (stderr, "%s: Could not open %s\n", *argv, argv[1]);
      return 1;
    }
  }
  else {
    fprintf (stderr, "%s: error: no input file\n", *argv);
    return 1;
  }
    
  h = htable_create(101, NULL);
  special_init();
  //printTopStaticPart();
  //printDrivePrototypeAndFunctionTop();
  yyparse();
  //printBottomStaticPart();
  free(file_name);
  htable_destroy(h);
  return 0;
}
