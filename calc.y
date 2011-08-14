%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define NO_SYMS 40
#define YYDEBUG 1

struct symbol {
    char *name;
    double value;
};

static int last_sym = 0;
static struct symbol syms[NO_SYMS];
static double mksym(char *, double);
static double getsym(char *);
%}
%union {
    char *varname;
    double number;
}

%token <number> NUM
%token <varname> VAR
%type <number> expr
%left '='
%left '-' '+'
%left '*' '/'
%left NEG
%right '^'
%%

statement: expr { printf(" = %f\n", $1); }
    | VAR '=' expr { mksym($1, $3); }
    ;

expr: NUM        { $$ = $1; }
    | VAR        { $$ = getsym($1); }
    | expr '+' expr { $$ = $1 + $3; }
    | expr '-' expr { $$ = $1 - $3; }
    | expr '*' expr { $$ = $1 * $3; }
    | expr '/' expr { $$ = $1 / $3; }
    | '-' expr %prec NEG { $$ = -$2; }
    | expr '^' expr { $$ = pow($1, $3); }
    |  '(' expr ')' { $$ = $2; }
    ;
%%

int main(void) {
    mksym("PI", 3.141592654);
    while (1) {
        printf("> ");
        yyparse();
    }
}

static double mksym(char *sym, double value)
{
    register int i;
    if (last_sym == NO_SYMS || last_sym < 0) {
        fprintf(stderr, "Too many symbols \'%s\' cannot added!\n", sym);
        exit(1);
    }

    // Find older definitions
    for (i = 0; i < last_sym; i++) {
        if (!strcmp(syms[i].name, sym))
            syms[i].value = value;
    }

    syms[last_sym].name = sym;
    syms[last_sym].value = value;
    last_sym++;
    return value;
}

static double getsym(char *sym)
{
    register int i;
    for (i = 0; i < last_sym; i++) {
        if (!strcmp(syms[i].name, sym))
            return syms[i].value;
    }
    fprintf(stderr, "Cannot find symbol \'%s\'!\n", sym);
    return 0;
}
