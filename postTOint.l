%{
#include<stdio.h>
#include<string.h>
#include<bits/stdc++.h>
using namespace std;
int i=0, temp=0, x=0, top=0;
string id, id1, id2, id3, id4;
stack<string> s;
%}
%%

[0-9]+ { id = yytext; i++; s.push(id);}
[ ] { }
[+|\-|*|'/'] { id1 = "("; id3 = s.top(); s.pop();id4 = s.top();s.pop(); id1+=id4;id1+=yytext;id1+=id3;id1+=")"; s.push(id1); }
. temp = 0;


%%
int main()
{
  yyin= fopen("expression.txt","r");
  yylex();
 // char str[100];
  //strcpy(str,pop());
  cout<<s.top();
  //printf("%s\n", s.top());

}

int yywrap()
{
  	return (1);
}









/*
%{
#include<stdio.h>
#include<string.h>
int i=0, temp=0, x=0, top=0;;
char id[10], id1[50], id2[50],id3[50], id4[50];
char stack[100][100];
void push(char*);
char* pop();
%}
%%

[0-9]+ { strcpy(id,yytext); i++; push(id);}
[ ] { }
[+|\-|*|'/'] { strcpy(id1,"("); strcpy(id3,pop()); strcpy(id4,pop()); strcat(id1,id4); strcat(id1,yytext); strcat(id1,id3); strcat(id1,")"); push(id1); }
. temp = 0;


%%
int main()
{
  yyin= fopen("expression.txt","r");
  yylex();
  char str[100];
  strcpy(str,pop());
  printf("%s\n", str);

}

int yywrap()
{
  	return (1);
}

void push(char* opnd){
	strcpy(stack[top],opnd);
	top++;
	printf("opnd %s\n", opnd);
	printf("push top %d\n", top);
}

char* pop(){
	strcpy(id2,stack[top-1]);
	printf("pop top %d\n", top);
	printf("pop %s\n", id2);
	top--;
	return id2;
}
*/