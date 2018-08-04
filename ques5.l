%{
#include <bits/stdc++.h>
using namespace std;

struct table
{
	string word;
	int count;
	set<int> s;
};
int line=1;
int other=0;
vector<table> arr;
void word(char*);

%}

%%
[A-Za-z']+ {word(yytext);}
[\n] {line++;}
. {other++;}
%%

main(void)
{
arr.clear();
yyin= fopen("inp5.txt","r");
yylex();
for(int i=0;i<arr.size();i++)
{
	cout<<arr[i].word<<"  "<<arr[i].count<<"------->";
	set<int>::iterator itr;
	for(itr=(arr[i].s).begin();itr!=(arr[i].s).end();itr++)
	{
		cout<<*itr<<" ";
	}
	cout<<"\n";
}
}

int yywrap()
{
return(1);
}

void word(char* text)
{
	string str(text);
	for(int i=0;i<str.length();i++)
	{
		if(str[i]>='A' && str[i]<='Z')
		{
			str[i]+=('a'-'A');
		}
	}
	bool found=false;
	for(int i=0;i<arr.size();i++)
	{
		if(str.compare(arr[i].word)==0)
		{
			(arr[i].s).insert(line);
			arr[i].count++;
			found=true;
			break;
		}
	}
	if(!found)
	{
		table obj;
		obj.word=str;
		obj.count=1;
		(obj.s).insert(line);
		arr.push_back(obj);
	}
}
