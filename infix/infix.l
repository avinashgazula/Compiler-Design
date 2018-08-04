%{

#include <bits/stdc++.h>
#include "infix.tab.h"
using namespace std;

void yyerror(char *);

%}

%%

[-+/*^=\);\n(]		{return yytext[0];}
[0-9]+				{yylval.val=atoi(yytext);return number;}
[a-zA-Z]+			{yylval.id=yytext[0];return identifier;}


%%

int yywrap(void){
	return 1;
}