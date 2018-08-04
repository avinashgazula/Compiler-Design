%{
   #include<stdlib.h>
   #include "temp.tab.h"
}%
%%
'+' {return ADD;}
'-' {return SUB;}
'/' {return DIV;}
'*' {return MUL;}
[0-9]+ {yylval.NUM=atoi(yytext);return NUMBER;}
[A-Za-z]+ {yylval.ID=yytext[0];return IDENTIFIER;}
%%

