%{
    #include <stdio.h>
    #include <string.h>

    #include "static.h"
    #include "variable.h"
    #include "hashtable.h"
  
    extern int yylineno;
    int yylex ();
    int yyerror ();

    struct hashtable * h = NULL;
    
%}

%union {
  int i;
  float f;
  char * s;
  struct Variable * var;
}

%token <s> IDENTIFIER
%token <f> CONSTANTF
%token <i> CONSTANTI

%token INC_OP DEC_OP LE_OP GE_OP EQ_OP NE_OP
%token SUB_ASSIGN MUL_ASSIGN ADD_ASSIGN
%token TYPE_NAME
%token INT
%token FLOAT
%token VOID
%type <var> declarator primary_expression postfix_expression unary_expression multiplicative_expression additive_expression comparison_expression
%type <var> expression
%token IF ELSE WHILE RETURN FOR

%start program
%%

primary_expression
: IDENTIFIER {if (htable_get(h, $1) == NULL) {
     htable_insert(h, $1, $1);
   }
 }
| CONSTANTI {$$->value = $1;}
| CONSTANTF {/*printf("%f\n", $1);*/};
| '(' expression ')' {$$ = $2;}
| IDENTIFIER '(' ')' {$$->name = strdup($1);}
| IDENTIFIER '(' argument_expression_list ')' {$$->name = strndup($1, V_NAME_SIZE);}
| IDENTIFIER INC_OP {$$->name = strdup($1);}
| IDENTIFIER DEC_OP {$$->name = strdup($1);}
;

postfix_expression
: primary_expression
| postfix_expression '[' expression ']'
;

argument_expression_list
: expression
| argument_expression_list ',' expression
;

unary_expression
: postfix_expression
| INC_OP unary_expression {$$ = $2;}
| DEC_OP unary_expression {$$ = $2;}
| unary_operator unary_expression {$$ = $2;}
;

unary_operator
: '-'
;

multiplicative_expression
: unary_expression
| multiplicative_expression '*' unary_expression
| multiplicative_expression '/' unary_expression
;

additive_expression
: multiplicative_expression
| additive_expression '+' multiplicative_expression
| additive_expression '-' multiplicative_expression
;

comparison_expression
: additive_expression
| additive_expression '<' additive_expression
| additive_expression '>' additive_expression
| additive_expression LE_OP additive_expression
| additive_expression GE_OP additive_expression
| additive_expression EQ_OP additive_expression
| additive_expression NE_OP additive_expression
;

expression
: unary_expression assignment_operator comparison_expression {
  if (strcmp($1->name, "$accel") == 0) {
    printf("\tstore float %f, float* %%accelCmd\n", $3->value);
  }
 }
| comparison_expression
;

assignment_operator
: '='
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
: IDENTIFIER {$$->name = $1;}
| '(' declarator ')' {$$->name = strdup($2->name);}
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
