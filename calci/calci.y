
%{
#include <stdio.h>
#include<math.h>
#include<string.h>
 char hexaDeciNum[100];
 char hexa[100];
char* decToHexa(int a);
int powe(int a,int b);
%}

%token NUMBER
%left ADD SUB MUL DIV ABS MOD
%left AND OR XOR
%right POW
%token EOL

%%
calclist: 
 | calclist bitor EOL { printf("= %s\n", decToHexa($2)); }
 ;
bitor:bitxor
   | bitor OR bitxor { $$ = $1 | $3; printf("%d  or  %d\n", $1,$3);}
   ;
bitxor:bitand
   | bitxor XOR bitand { $$ = $1 ^ $3; printf("%d  xor  %d\n", $1,$3);}
   ;
bitand:exp
   | bitand AND term { $$ = $1 & $3; printf("%d  and  %d\n", $1,$3);}
   ;
exp: factor
 | exp ADD factor { $$ = $1 + $3; printf("%d  added  %d\n", $1,$3);}
 | exp SUB factor { $$ = $1 - $3;printf("%d  subtract  %d\n", $1,$3);}
 ;
factor: powterm
 | factor MUL powterm { $$ = $1 * $3;printf("%d  multiply  %d\n", $1 ,$3);}
 | factor DIV powterm { $$ = $1 / $3;printf("%d  divide  %d\n", $1 ,$3);}
 | factor MOD powterm { $$ = $1 % $3;printf("%d  modulus  %d\n", $1 ,$3);}
 ;

powterm:term
  | term POW powterm { $$ = powe($1,$3);printf("%d  raisedto  %d\n", $1 ,$3);}
  ;
term: NUMBER 
 | ABS term { $$ = $2 >= 0? $2 : - $2;printf("%d ", $2 );}
 ;
%%
int main(int argc, char **argv)
{
 yyparse();
}
char* decToHexa(int n)
{   

    int i = 0;
	for(i=0;i<100;i++)
	{
		hexa[i]='\0';
		hexaDeciNum[i]='\0';
	}
    // char array to store hexadecimal number
   
     
    // counter for hexadecimal number array
    printf("Ans in Decimal = %d\n",n);
    i=0;
    while(n!=0)
    {   
        // temporary variable to store remainder
        int temp  = 0;
         
        // storing remainder in temp variable.
        temp = n % 16;
         
        // check if temp < 10
        if(temp < 10)
        {
            hexaDeciNum[i] = temp + 48;
            i++;
        }
        else
        {
            hexaDeciNum[i] = temp + 55;
            i++;
        }
         
        n = n/16;
    }
   //   printf("AnsA =%s ",hexaDeciNum);
    // printing hexadecimal number array in reverse order
    int j=0;
    for(i=strlen(hexaDeciNum)-1;i>=0;i--)
	{
		hexa[j++]=hexaDeciNum[i];
	}
   // printf("Ans =%s ",hexa);
   return (char*)hexa;
}

int powe(int a,int b)
{
	int ans=1,i;
	for(i=1;i<b;i++)
	{
	ans=ans*a;
	}
	return ans;
}
int yyerror(char *s)
{
 fprintf(stderr, "error: %s\n", s);
}
