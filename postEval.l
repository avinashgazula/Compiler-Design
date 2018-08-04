%{
#include<stdio.h>
#include<string.h>
int i=0, temp=0, x=0, top=0;float a,b,val=0, id2;
char id[10];
float stack[100];
void push(float);
float pop();
%}
%%

[0-9]+ { strcpy(id,yytext); i++; push((float)atoi(id));}
[ ] { }
[+] {  a=pop(); b=pop() ; val=b+a; push(val); }
[\-] {  a=pop(); b=pop() ; val=b-a; push(val); }
[*] {  a=pop(); b=pop() ; val=b*a; push(val); }
['/'] { a=pop(); b=pop() ; val=b/a; push(val); }
. temp = 0;


%%
int main()
{
  yyin= fopen("expression.txt","r");
  yylex();
  //char str[100];
  //strcpy(str,pop());
  printf("Value : %.2f\n", pop());

}

int yywrap()
{
  	return (1);
}

void push(float opnd){
	stack[top]=opnd;
	top++;
	//printf("opnd %.2f\n", opnd);
	//printf("push top %d\n", top);
}

float pop(){
	id2=stack[top-1];
	//printf("pop top %d\n", top);
	//printf("pop %s\n", id2);
	top--;
	return id2;
}
