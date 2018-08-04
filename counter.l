%{
#include<stdio.h>
int lines=0, words=0,s_letters=0,c_letters=0, num=0, spl_char=0,total=0, numbers=0, floats=0;
%}
%%

[\n]+ {words++;lines+=yyleng;}
[\0] lines++;
[\t ]+ words++;
[A-Z] c_letters++;
[a-z] s_letters++;
[0-9]+[.][0-9]+ {numbers++; num+=yyleng;num--;}
[0-9]+ {numbers++; num+=yyleng;}
. spl_char++;
%%


int main()
{
  yyin= fopen("myfile.txt","r");
  yylex();
  total=s_letters+c_letters+num+spl_char+floats;
  printf("\n\t%d lines", lines+1);
  printf("\n\t%d words",words-1-numbers-1);
  printf("\n\t%d small letters", s_letters);
  printf("\n\t%d capital letters",c_letters);
  printf("\n\t%d numbers", numbers);
  printf("\n\t%d digits", num);
  printf("\n\t%d special characters",spl_char);
  printf("\n\tIn total %d characters.\n",total);
}

int yywrap()
{
  return (1);
}

