%{
    #include <stdio.h>
    #include <string.h>

    #include "static.h"
  //#include "variable.h"
    #include "hashtable.h"
  //#include "type.h"

    extern int yylineno;
    int yylex ();
    int yyerror ();

    struct hashtable * h = NULL;

%}

%union {
  /* int i; */
  /* float f; */
  /* char * s; */
  char * code;
struct Variable {
  //char flags; // Contains several informations : TODO|..|GLOBAL|WRITABLE|DECLARED
  enum Type { INTEGER, INTPOINTER, REAL, REALPOINTER,EMPTY, STRING, FUNCTION,OPERATOREQUAL }type;
  char * name;//char name[V_NAME_SIZE];
  char * llvm_name;
  float value; // Store int in a float
  //char code[CODE_SIZE];
} var;

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
%type <var> expression
%token IF ELSE WHILE RETURN FOR

%start program
%%

primary_expression
: IDENTIFIER {if (htable_get(h, $1.name) == NULL) {
     htable_insert(h, $1.name, (void*) &$1);
   }
   else{}
   
   $$.llvm_name = malloc(strlen($1.name + 10) * sizeof(char));
   sprintf($$.llvm_name,"%%%sCmd", ($1.name+1));
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
: postfix_expression{$$.value=$1.value;}
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
: unary_expression assignment_operator comparison_expression {
  /* if (strcmp($1.name, "$accel") == 0) { */
  /*   printf("\tstore float %f, float* %%accelCmd\n", $3.value); */
  /* } */
  if($2.type==OPERATOREQUAL){
    if($3.type==REAL){
      printf("store float %f, ",$3.value);
    }
    if($1.type==REALPOINTER){ printf(" float* ");}
    printf("%s",$1.llvm_name);
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
: type_name declarator_list ';'
;

declarator_list
: declarator
| declarator_list ',' declarator
;

type_name
: VOID  
| INT   
| FLOAT
;

declarator
: IDENTIFIER {$$.name = $1.name;}
| '(' declarator ')' {$$.name = strdup($2.name);}
| declarator '[' CONSTANTI ']'
| declarator '[' ']'
| declarator '(' parameter_list ')'
| declarator '(' ')'
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
| expression_statement 
| selection_statement
| iteration_statement
| jump_statement
;

compound_statement
: '{' '}'
| '{' statement_list '}'
| '{' declaration_list statement_list '}'
;

declaration_list
: declaration
| declaration_list declaration
;

statement_list
: statement
| statement_list statement
;

expression_statement
: ';'
| expression ';'
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
: type_name declarator compound_statement
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
    
    printTopStaticPart();
    printDrivePrototypeAndFunctionTop();

    yyparse();
    printDriveFunctionEnd();
    printBottomStaticPart();
    free(file_name);
    htable_destroy(h);
    return 0;
}
