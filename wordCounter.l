%{
#include<bits/stdc++.h>
#include<stdio.h>
#include<string.h>
#include<map>
#include<set>
using namespace std;
struct symbol{
  string word;
  int count;
  set<int> line;
};
set<string> words;
int lineno = 1;
vector<symbol> wordCount;
void present(string);
void notPresent(string);
%}
%%

[a-zA-Z\']+ { string str(yytext);if(words.find(str) == words.end()) { notPresent(str); } else { present(str);}}
[\n]+ {lineno+=yyleng;}
[\0] lineno++;

%%
int main()
{
  yyin= fopen("textfile.txt","r");
  yylex();
  for(int i=0; i<wordCount.size(); i++){
    cout<<wordCount[i].word<<" "<<wordCount[i].count<<"          ";
    for(set<int>::iterator a = (wordCount[i].line).begin(); a != (wordCount[i].line).end(); a++){
      cout<<*a<<",";
    }
    cout<<endl;
  }

}

int yywrap()
{
  	return (1);
}

void notPresent(string str){
  words.insert(str);
  struct symbol s;
  s.word = str;
  s.count = 1;
  s.line.insert(lineno);
  wordCount.push_back(s);
}

void present(string str){
  for(int i=0; i<wordCount.size(); i++){
    if(wordCount[i].word == str){
      wordCount[i].count++;
      (wordCount[i].line).insert(lineno);
    }
  }
}
