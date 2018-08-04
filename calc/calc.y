
%{
#include <stdio.h>
%}

%token NUMBER
%token ADD SUB MUL DIV ABS
%token EOL

%%
calclist: 
 | calclist exp EOL { printf("= %d\n", $2); } 
 ;
exp: factor
 | exp ADD factor { $$ = $1 + $3; printf("%d  adding  %d\n", $1,$3);}
 | exp SUB factor { $$ = $1 - $3;printf("%d  subtracting  %d\n", $1,$3); }
 ;
factor: term 
 | factor MUL term { $$ = $1 * $3;printf("%d  multiplying  %d\n", $1 ,$3);}
 | factor DIV term { $$ = $1 / $3;printf("%d  dividing  %d\n", $1 ,$3);}
 ;
term: NUMBER 
 | ABS term { $$ = $2 >= 0? $2 : - $2;printf("%d ", $2 );}
;
%%
main(int argc, char **argv)
{
 yyparse();
}
yyerror(char *s)
{
 fprintf(stderr, "error: %s\n", s);
}
