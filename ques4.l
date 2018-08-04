%{
#include<stdio.h>
#include <bits/stdc++.h>
using namespace std;

ofstream fout;
int k=5;

void word(char*);
void number(char*);
bool is_spec(string);
void other(char*);
%}


%%
[a-zA-Z]+ {word(yytext);}
[0-9]+ {number(yytext);}
. {other(yytext);}
%%

main(void)
{
fout.open("output.txt");
yyin= fopen("inp4.txt","r");
yylex();
}

int yywrap()
{
return(1);
}
bool is_spec(string str)
{
	ifstream fin;
	fin.open("spec.txt");
	string s;
	while(fin>>s)
	{
		if(str.compare(s) == 0)
			return 1;
	}
	return 0;
}
void word(char* text)
{
	string str(text);
	cout<<str<<"----";
	if(is_spec(str))
	{
		int n=str.length();
		if(n>2)
		{
			char a,b;
			a=str[0];
			b=str[1];
			for(int i=0;i<n-2;i++)
			{
				str[i]=str[i+2];
			}
			str[n-2]=a;
			str[n-1]=b;
		}
	}
	else
	{
		 for(int i=0;i<str.length();i++)
		 {
		 	int p;
		 	if(str[i]>='a' && str[i]<='z')
		 	{
		 		p=str[i]-'a'+1;
		 		p=(p+k)%27;
		 		str[i]=p+'a'-1;
		 	}
		 	if(str[i]>='A' && str[i]<='Z')
		 	{
		 		p=str[i]-'A'+1;
		 		p=(p+k)%27;
		 		str[i]=p+'A'-1;
		 	}
		 }
	}
	reverse(str.begin(), str.end());
	cout<<str<<"\n";
	fout<<str;
}
void number(char* text)
{
	string str(text);
	cout<<str<<"----";
	int n=str.length();
	for(int i=0;i<n/2;i++)
	{
		if(n%2==0)
		{
			char temp=str[i];
			str[i]=str[i+n/2];
			str[i+n/2]=temp;
		}
		else
		{
			char temp=str[i];
			str[i]=str[i+n/2+1];
			str[i+n/2+1]=temp;
		}
	}
	cout<<str<<"\n";
	fout<<str;
}
void other(char* text)
{
	string str(text);
	cout<<str<<"----";

	cout<<str<<"\n";
	fout<<str;
}
