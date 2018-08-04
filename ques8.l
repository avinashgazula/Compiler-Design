%{
#include <bits/stdc++.h>
using namespace std;
%}

letter [A-Za-z]
digit [0-9]
id {letter}({letter}|{digit})*
number [digit]+

%%
{id} {cout<<yytext<<endl;}
[0-9]+ {cout<<yytext<<endl;}
[<]+ {cout<<yytext<<endl;}
[>]+ {cout<<yytext<<endl;}
[+*/-] {cout<<yytext<<endl;}
[=] {cout<<yytext<<endl;}
. {}
%%

main(void)
{
yyin= fopen("inp8.txt","r");
yylex();
}

int yywrap()
{
return(1);
}
