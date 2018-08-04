%{
   #include<stdlib.h>
   #include<unistd.h>
   int a;
%}

%union {char ID;int NUM;}
%token NUMBER IDENTIFIER ADD SUB DIV MUL
;%start line 
%type<ID> IDENTIFIER ADD SUB DIV MUL
%type<NUM> NUMBER line exp factor term 

%%
line: exp '\n' {printf("val = %d",$1);}
    ;
exp: factor
    | exp ADD factor {$$ = $1 + $3;}
    | exp SUB factor {$$ = $1 - $3;}
    ;
factor: term
       | factor MUL term {$$ = $1 * $3;}
       | factor DIV term {$$ = $1 / $3;}
       ;
term: NUMBER {$$ = $1;}
     ;
%% 

int main()
{
    yyparse();
    return 0;
}
void yyerror(char* s)
{
    fprintf(stderr," error %s",s);
}
