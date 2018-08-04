%{
    #include<stdio.h>
    int x;
%}
%union{char ID;int NUM;}
%token ADD MUL SUB DIV ABS
%token NUMBER
%token IDENTIFIER
%token EOL
%type<ID> ADD MUL SUB DIV ABS IDENTIFIER
%type<NUM> NUMBER level0 level1 level2 level3 
%%
level4:
      | level4 level3 EOL 
      ;
level3: level2 {$$=$1;printf("%d\n",$1);}
      | IDENTIFIER '=' level2 {x=$3;$$=$1;printf("%c=%d\n",$1,x);}
      ;
level2: level1
 | level2 ADD level1 {$$ = $1+$3;}
 | level2 SUB level1 {$$ = $1-$3;}
 ;

level1: level0
 | level1 MUL level0 {$$ = $1*$3;}
 | level1 DIV level0 {$$ = $1/$3;}
 ;

level0: NUMBER
 | ABS level0 {if($2<0) $2 = -1*$2; $$=$2;}
 ;
%%
int main(int argc, char **argv){
    yyparse();
}
int yyerror(char *s)
{
 fprintf(stderr, "error: %s\n", s);
}