%{
#include<stdio.h>
#include <bits/stdc++.h>
using namespace std;

ofstream fout;
stack<string> st; 
char ch[8];

void ident(char*);
void symbol(char*);
void bracket(char*);
bool pref(string ,string);
void evaluate();
double hex_dec(string);
%}

letter [A-Za-z]
digit [0-9]
id {letter}({letter}|{digit})*
number [digit]+

%% 
[0-9A-F.]+ {ident(yytext);}
[+*/%/-|&^] {symbol(yytext);}
[()] {bracket(yytext);}
%%

main(void)
{
fout.open("postfix.txt");
cout<<"enter pref order\n";
for(int i=0;i<8;i++)
{
	cin>>ch[i];
}
yyin= fopen("infix.txt","r");
yylex();
while(!st.empty())
{
	fout<<st.top()<<" ";
	st.pop();
}
fout.close();

evaluate();

}

int yywrap()
{
return(1);
}
bool pref(string stp, string s)
{
	char a,b;
	a=stp[0];
	b=s[0];
	if(a=='(')
	{
		return false;
	}
	int x,y;
	for(int i=0;i<8;i++)
	{
		if(ch[i]==a)
			x=i;
		if(ch[i]==b)
			y=i;
	}
	if(x<y)
	{
		return true;
	}
	else
	{
		return false;
	}
}
void ident(char* text)
{
	string str(text);
	fout<<str<<" ";
}
void symbol(char* text)
{
	string str(text);
	while(!st.empty() && pref(st.top(),str))
	{
		fout<<st.top()<<" ";
		st.pop();
	}
	st.push(str);
}
void bracket(char* text)
{
	string str(text);
	if(str[0]=='(')
	{
		st.push(str);
	}
	else
	{
		string ch1=st.top();
		while(ch1[0]!='(')
		{
			ch1=st.top();
			if(ch1[0]!='(')
				fout<<ch1<<" ";
			st.pop();
		}
	}
}
void evaluate()
{
	stack<int> sta;
	string str;
	ifstream fin;
	fin.open("postfix.txt");
	while(fin>>str)
	{
		char x=str[0];
		if(x=='+'||x=='-'||x=='*'||x=='/'||x=='%'||x=='|'||x=='^'||x=='&')
		{
			if(x=='+')
			{
				cout<<"adding\n";
				double a,b;
				a=sta.top();
				sta.pop();
				b=sta.top();
				sta.pop();
				sta.push(a+b);
				cout<<"pushed : "<<b+a<<endl;
			}
			else if(x=='-')
			{
				cout<<"subtract\n";
				double a,b;
				a=sta.top();
				sta.pop();
				b=sta.top();
				sta.pop();
				sta.push(b-a);
				cout<<"pushed : "<<b-a<<endl;
			}
			else if(x=='*')
			{
				cout<<"multiply\n";
				double a,b;
				a=sta.top();
				sta.pop();
				b=sta.top();
				sta.pop();
				sta.push(b*a);
				cout<<"pushed : "<<b*a<<endl;
			}
			else if(x=='/')
			{
				cout<<"divide\n";
				double a,b;
				a=sta.top();
				sta.pop();
				b=sta.top();
				sta.pop();
				sta.push(b/a);
				cout<<"pushed : "<<b/a<<endl;
			}
			else if(x=='%')
			{
				cout<<"remainder\n";
				int a,b;
				a=sta.top();
				sta.pop();
				b=sta.top();
				sta.pop();
				sta.push(double(b%a));
				cout<<"pushed : "<<b%a<<endl;
			}
			else if(x=='&')
			{
				cout<<"and\n";
				int a,b;
				a=sta.top();
				sta.pop();
				b=sta.top();
				sta.pop();
				sta.push(double(b&a));
				cout<<"pushed : "<<(b&a)<<endl;
			}
			else if(x=='|')
			{
				cout<<"or\n";
				int a,b;
				a=sta.top();
				sta.pop();
				b=sta.top();
				sta.pop();
				int d=a|b;
				sta.push(double(d));
				cout<<"pushed : "<<d<<endl;
			}
			else if(x=='^')
			{
				cout<<"xor\n";
				int a,b;
				a=sta.top();
				sta.pop();
				b=sta.top();
				sta.pop();
				sta.push(double(b^a));
				cout<<"pushed : "<<(b^a)<<endl;
			}
		}
		else
		{
			double x=hex_dec(str);
			sta.push(x);
			cout<<"pushed : "<<x<<endl;
		}
	}
}
double hex_dec(string str)
{
	int k=1;
	double res=0;
	for(int i=str.length()-1;i>=0;i--)
	{
		char p =str[i];
		int ab;
		if(p>='0' && p<='9')
		{
			ab=p-'0';
		}
		else
		{
			ab=p-'A'+10;
		}
		res=res+(ab*k);
		k=k*16;
	}
	return res;
}