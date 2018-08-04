%{
#include "calc.tab.h"
#include<stdio.h>
#include<stdlib.h>

char a[10];

%}
%%
"+" {return ADD;}
"-" {return SUB;}
"*" {return MUL;}
"/" {return DIV;}
"|" {return ABS;}
[0-9]+ {yylval =atoi(yytext);return NUMBER;}
[-][0-9]+ {for(int i=1; i<yyleng; i++){a[i-1]=yytext[i];} yylval = -1*atoi(a); return NUMBER;}
\n {return EOL;}
[ \t] {}
.    {}

%%


