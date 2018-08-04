%{
#include<string.h>
#include<math.h>
#include "calci.tab.h"
hexadecimalToDecimal(char* s);
%}

%%
"+" {return ADD;}
"-" {return SUB;}
"*" {return MUL;}
"/" {return DIV;}
"%" {return MOD;}
"|"[0-9A-F]+"|" {return ABS;}
"|" {return OR;}
"^" {return XOR;}
"&" {return AND;}
"**" {return POW;}
[0-9A-F]+ {yylval = hexadecimalToDecimal(yytext);return NUMBER;}
\n {return EOL;}
[ \t] {}
.    {}

%%
int hexadecimalToDecimal(char hexVal[])
{   
    int len = strlen(hexVal);
     
    // Initializing base value to 1, i.e 16^0
    int base = 1;
     
    int dec_val = 0;
     
    // Extracting characters as digits from last character
    for (int i=len-1; i>=0; i--)
    {   
        // if character lies in '0'-'9', converting 
        // it to integral 0-9 by subtracting 48 from
        // ASCII value.
        if (hexVal[i]>='0' && hexVal[i]<='9')
        {
            dec_val += (hexVal[i] - 48)*base;
                 
            // incrementing base by power
            base = base * 16;
        }
 
        // if character lies in 'A'-'F' , converting 
        // it to integral 10 - 15 by subtracting 55 
        // from ASCII value
        else if (hexVal[i]>='A' && hexVal[i]<='F')
        {
            dec_val += (hexVal[i] - 55)*base;
         
            // incrementing base by power
            base = base*16;
        }
    }
     printf("the number in decimal base 10 is  = %d\n",dec_val);
    return dec_val;
}




