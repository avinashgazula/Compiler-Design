%{
#include<string.h>
#include "compiler.tab.h"
#include<stdio.h>

%}

letter [A-Za-z]
digit [0-9]
id {letter}({letter}|{digit})*
number [digit]+
datatype "int"|"bool"|"unsigned int" 
boolValue "true"|"false"
cond_while "while"
relop "<"|">"|"<="|">="|"=="|"!="

%%
{datatype} {strcpy(yylval.str,yytext); /*printf("L %s\n",yylval.str);*/ return types;}
{boolValue} {strcpy(yylval.str,yytext); /*printf("L %s\n",yylval.str);*/ return bval;}
{id} {strcpy(yylval.str,yytext); /*printf("L %s\n",yylval.str);*/ return ID;}
{relop} {strcpy(yylval.str,yytext); /*printf("L %s\n",yylval.str);*/ return RELOP;}
[;={}()!] {/*printf("L %s\n", yytext);*/ return yytext[0];}
[0-9]+ { strcpy(yylval.str,yytext); /*printf("L %s\n",yylval.str);*/ return ival;}
"+" {return ADD;}
"-" {return SUB;}
"*" {return MUL;}
"/" {return DIV;}
"|" {return OR;}
"^" {return XOR;}
"&" {return AND;}
"@" {return POW;}
"~" {return NEG;}
\n {return EOL;}
[' '] {return SPACE;}
%%

