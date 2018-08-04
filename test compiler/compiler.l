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
relop "<"|">"|"<="|">="|"=="|"!="

%%
{datatype} {strcpy(yylval.str,yytext); return types;}
{boolValue} {strcpy(yylval.str,yytext); return bval;}
"while" {strcpy(yylval.str,yytext); return WHILE;}
"if" {strcpy(yylval.str,yytext); return IF;}
"else" {strcpy(yylval.str,yytext); return ELSE;}
"switch" {strcpy(yylval.str,yytext); return SWITCH;}
"case" {strcpy(yylval.str,yytext); return CASE;}
"break" {strcpy(yylval.str,yytext); return BREAK;}
"default" {strcpy(yylval.str,yytext); return DEFAULT;}
{id} {strcpy(yylval.str,yytext); return ID;}
{relop} {strcpy(yylval.str,yytext); return RELOP;}
[;:={}()!] {/*printf("L %s\n", yytext);*/ return yytext[0];}
[0-9]+ { strcpy(yylval.str,yytext); return ival;}
"&&" {return BAND;}
"||" {return BOR;}
"+" {return ADD;}
"-" {return SUB;}
"*" {return MUL;}
"/" {return DIV;}
"|" {return OR;}
"^" {return XOR;}
"&" {return AND;}
"@" {return POW;}
"~" {return NEG;}
\n {}
[' '] {}
%%

