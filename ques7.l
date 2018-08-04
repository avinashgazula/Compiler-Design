%{
#include<stdio.h>
#include <bits/stdc++.h>
using namespace std;

ofstream fout;
stack<string> st; 
char ch[5];

void ident(char*);
void symbol(char*);
void bracket(char*);
bool pref(string ,string);
void evaluate();
%}

%% 
[0-9.]+ {ident(yytext);}
[+*%/-] {symbol(yytext);}
[()] {bracket(yytext);}
%%

int main(void)
{
	fout.open("postfix1.txt");
	cout<<"enter pref order\n";
	for(int i=0;i<5;i++)
	{
		cin>>ch[i];
	}
	yyin= fopen("infix1.txt","r");
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
	for(int i=0;i<5;i++)
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
	stack<double> sta;
	string str;
	ifstream fin;
	fin.open("postfix1.txt");
	while(fin>>str)
	{
		char x=str[0];
		if(x=='+'||x=='-'||x=='*'||x=='/'||x=='%')
		{
			double a,b;
			a=sta.top();
			sta.pop();
			b=sta.top();
			sta.pop();
			if(x=='+')
			{
				sta.push(a+b);
				cout<<"pushed "<<a+b<<endl;
			}
			else if(x=='-')
			{
				sta.push(b-a);
				cout<<"pushed "<<b-a<<endl;
			}
			else if(x=='*')
			{
				sta.push(b*a);
				cout<<"pushed "<<b*a<<endl;
			}
			else if(x=='/')
			{
				sta.push(b/a);
				cout<<"pushed "<<b/a<<endl;

			}
		}
		else
		{
			double p = ::atof(str.c_str());
			sta.push(p);
			cout<<"pushed"<<p<<endl;
		}
	}
	cout<<endl;
	cout<<"the res is "<<sta.top()<<endl;
}
