%{
#include <stdio.h>
#include <string.h>

#include "static.h"
#include "hashtable.h"
  
  extern int yylineno;
  int yylex ();
  int yyerror ();

  struct hashtable * h = NULL;
  char tmpnumber[20];

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
     printf("key :%s\n",$1.name);
     perror("ID not in htable yet");
     htable_insert(h, $1.name, (void*) &$1);
   //copy of var name from ID to primary expression
   strcpy($$.name,$1.name);
   
   //creation of llvm_name from ID to primary expression
   $$.llvm_name = malloc(strlen($1.name + 10) * sizeof(char));
   sprintf($$.llvm_name,"%%%sCmd", ($1.name+1));
   //the value is in the htable. key==name (NOT LLVM NAME)
   printf("in htable key : %s nom : %s \n",$$.name,((struct Variable *)htable_get(h,$$.name))->name);
   //perror("Primary Expression IDENTIFIER");
   
 }
| CONSTANTI {$$.value = $1.value;}
| CONSTANTF {$$.value = $1.value;}
| '(' expression ')' {/*$$ = $2;*/}
| IDENTIFIER '(' ')' {}
| IDENTIFIER '(' argument_expression_list ')' {}
| IDENTIFIER INC_OP {}
| IDENTIFIER DEC_OP {}
;

postfix_expression
: primary_expression {$$.value=$1.value; $$.llvm_name=$1.llvm_name;}
| postfix_expression '[' expression ']'
;

argument_expression_list
: expression
| argument_expression_list ',' expression
;

unary_expression
: postfix_expression{$$.value=$1.value; }
| INC_OP unary_expression {$$ = $2;}
| DEC_OP unary_expression {$$ = $2;}
| unary_operator unary_expression {$$ = $2;}
;

unary_operator
: '-'
;

multiplicative_expression
: unary_expression{$$.value=$1.value;}
| multiplicative_expression '*' unary_expression
| multiplicative_expression '/' unary_expression
;

additive_expression
: multiplicative_expression{$$.value=$1.value;}
| additive_expression '+' multiplicative_expression
| additive_expression '-' multiplicative_expression
;

comparison_expression
: additive_expression{$$.value=$1.value;}
| additive_expression '<' additive_expression
| additive_expression '>' additive_expression
| additive_expression LE_OP additive_expression
| additive_expression GE_OP additive_expression
| additive_expression EQ_OP additive_expression
| additive_expression NE_OP additive_expression
;

expression
: unary_expression assignment_operator comparison_expression  {
  /* if (strcmp($1.name, "$accel") == 0) { */
  /*   printf("\tstore float %f, float* %%accelCmd\n", $3.value); */
  /* } */
  if ($2.type == OPERATOREQUAL) { // If it is an affectation

    printf("Affectation..\n");

    struct Variable * var_left = malloc(sizeof(struct Variable));
    struct Variable * var_right = malloc(sizeof(struct Variable));
    var_left = (struct Variable *) htable_get(h, $1.name);
    var_right = (struct Variable *) htable_get(h, $3.name);
    
    /* Debug */
    printf("unary_expression name : %s\n", $1.name);
    printf("name : %s\n", var_left->name);
    printf("type : %d\n", var_left->type);
    printf("comparison_expression name : %s\n", $3.name);
    printf("name : %s\n", var_right->name);
    printf("type : %d\n", var_right->type);
    /* Debug */
    
    if (var_left->type != var_right->type) {
      yyerror("Erreur : impossible d'affecter un %s dans un %s !\n", get_type_string(var_right->type), get_type_string(var_left->type));
    }
      
    switch (var_left->type) {
    case REAL :
      printf("%s = fadd %f, 0.0\n", var_left->llvm_name, $3.value);
      break;
    default:
      printf("default\n");
    }
    
  }
  if (strcmp($1.name, "$accel") == 0) {
    //perror("exp st $accel");
    if($2.type==OPERATOREQUAL){
      //perror("exp st $accel =");
      if($3.type==REAL){
	/* float f=$3.value; */
	/* sprintf(chartmp,"%f",f); */
	/* strcat($$,"store float "); */
	/* strcat($$,chartmp); */
	/* sprintf($$,"float* %s\n",$1.llvm_name); */
      }
      if($3.type==INTEGER){
	sprintf(tmpnumber,"%d",(int)$3.value);
	strcat($$,$1.llvm_name);
	strcat($$," = add i32 0, ");
	strcat($$,tmpnumber);
      }
      if($1.type==REALPOINTER){ 
	printf(" float* ");
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
  //printf("angle ? hashage %d \n",((struct Variable *)htable_get(h,"angle"))->type);
  // Be Carefull a declaration is not printed
  // in the llvm code.
  /*jump a line after each declaration
  //strcat($2,"\n"); 
  // copy the declarators' list into type name
  //strcat($1,$2); 
  // copy the whole thing into declaration
  //strcpy($$,$1); */
  
 }
;

declarator_list
: declarator {strcpy($$,$1.name);}
| declarator_list ',' declarator{strcat($1,",");strcat($1,$3.name);strcpy($$,$1);}
;

type_name
: VOID{$$=EMPTY;}
| INT{}   
| FLOAT{$$=REAL;/* strcpy($$,"float "); */}
;

declarator
: IDENTIFIER {$$.name= $1.name;
   htable_insert(h,$1.name,(void *)&$1);
 }
| '(' declarator ')' {$$.name = strdup($2.name); sprintf($$.code,"(%s)",$$.name); }
| declarator '[' CONSTANTI ']'
| declarator '[' ']'
| declarator '(' parameter_list ')' {}
| declarator '(' ')' {$$.name = strdup($1.name); sprintf($$.code,"%s ()",$$.name);}
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
| expression_statement{strcpy($$,$1);} 
| selection_statement
| iteration_statement
| jump_statement
;

compound_statement
: '{' '}'
| '{' statement_list '}'{strcpy($$,$2); }
| '{' declaration_list statement_list '}' {strcat($2,$3); strcpy($$,$2);}
;

declaration_list
: declaration {strcpy($$,$1);}
| declaration_list declaration
;

statement_list
: statement{strcpy($$,$1);}
| statement_list statement
;

expression_statement
: ';'
| expression ';'{strcpy($$,$1);}
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
: type_name declarator compound_statement{printf("%s",get_type_string($1)); printf("%s ",$2.code); printf("{\n %s \n}\n",$3);}
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
    
  //printTopStaticPart();
  //printDrivePrototypeAndFunctionTop();
  yyparse();
  //printDriveFunctionEnd();
  //printBottomStaticPart();
  free(file_name);
  htable_destroy(h);
  return 0;
}
