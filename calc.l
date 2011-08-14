%{
#include <stdlib.h>
#include "y.tab.h"
%}

%%

[0-9]+ { yylval = atoi(yytext); return NUMBER; }

[-+*/()^] return *yytext; 

[\t ]+ ; 

\n return 0; 

q exit(0);

%%
