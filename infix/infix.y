%{

#include <bits/stdc++.h>
using namespace std;
void yyerror(char* s);
int yylex();

%}

%union {int val;char id;}


%left '+''-'
%left '/''*'
%right '^'


%token <val> number;
%token <id> identifier;

%type <id> start;
%type <val> exp level;
%type <id> ident;

%%

start	: start level '\n'		{printf("%d",$2);}
         | level '\n'		{printf("%d\n",$1);}
		 | start exp '\n' {printf("%d\n",$2);}
		 | exp '\n' {printf("%d\n",$1);}
		;
level : identifier '=' exp 		{printf("%c is assigned %d\n",$1,$3); $$=$3;}
      ;
exp		:	number					{$$=$1;}
		|	exp '+' exp				{$$=$1+$3;}
		|	exp '-' exp				{$$=$1-$3;}
		|	exp '*' exp				{$$=$1*$3;}
		|	exp '/' exp				{$$=$1/$3;}
		|	exp '^' exp				{$$=pow($1,$3);}
		;


%%

void yyerror(char* s){
	printf("\nError = %s\n",s);
	return;
}

int main(){
	yyparse();
}