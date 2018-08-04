%{
#include<stdio.h>
#include<bits/stdc++.h>
using namespace std;

struct variable{
string type;
string name;
string value;
};
vector<variable> table;
int yylex(void);
void yyerror(char *);
void printTable();
void intialiseValue(char*, char*);
int findVal(char*);
int powe(int,int);
string threeAddress(char*, char*, string);
string threeAddress(char*, string);


int tcount=0;
map<int, string> tvalues;
%}
%union 
{
        int number;
        char str[100];
}
%token <str> types ID RELOP ival bval c_while boolValue
%token <number> intVal
%token ADD SUB MUL DIV ABS NEG EOL SPACE 
%left AND OR XOR
%right POW
%type <str> declarations datatype identifier initialisation 
%type <str> eval bitor bitxor bitand exp factor powterm term bitneg
%type <str> booleval bool_and bool_not bool_rel 

%%
S: 
 | S declarations EOL {printTable();}
 | S initialisation EOL {printTable();}
 | S eval EOL {printTable(); tcount =0; tvalues.clear();} 
 | c_while '(' booleval ')' '{' S '}' EOL {}
 | S booleval EOL {}
 ;
booleval:bool_and
 | booleval OR OR bool_and { strcpy($$,((threeAddress($1, $4, "||")).c_str())); }
 ;
bool_and:bool_not
 | bool_and AND AND bool_not {strcpy($$,((threeAddress($1, $4, "&&")).c_str()));}
 ; 
bool_not:bool_rel
 | NEG bool_not {
       strcpy($$,((threeAddress($2, "!")).c_str()));} 
 ;
bool_rel:boolValue {strcpy($$, $1);}
 | term RELOP term { string relop($2); strcpy($$,((threeAddress($1, $3, relop)).c_str()));}
 ;

eval : ID '=' bitor ';'{ 
    int c1;
    string s1($3);
    for(map<int, string> ::iterator itr = tvalues.begin(); itr!=tvalues.end(); itr++){
      if(itr->second == s1) c1 = itr->first;
    }
    cout<<$1<<" = t"<<c1<<endl;
	}
 ;
bitor:bitxor
   | bitor OR bitxor { 
  strcpy($$,((threeAddress($1, $3, "|")).c_str()));}
   ;
bitxor:bitand
   | bitxor XOR bitand { 
  strcpy($$,((threeAddress($1, $3, "^")).c_str()));}
   ;
bitand:bitneg
   | bitand AND term { 
  strcpy($$,((threeAddress($1, $3, "&")).c_str()));}
   ;
bitneg:exp
   | NEG exp {
       strcpy($$,((threeAddress($2, "~")).c_str()));} 
   ;
exp: factor
 | exp ADD factor { 
  strcpy($$,((threeAddress($1, $3, "+")).c_str()));}
 | exp SUB factor { 
  strcpy($$,((threeAddress($1, $3, "-")).c_str()));}
 ;
factor: powterm 
 | factor MUL term { 
  strcpy($$, ((threeAddress($1, $3, "*")).c_str()));}
 | factor DIV term { 
  strcpy($$,((threeAddress($1, $3, "/")).c_str()));}
 ;
powterm:term
  | term POW powterm { 
  strcpy($$,((threeAddress($1, $3, "@")).c_str()));
  }
  ;
term: ival { strcpy($$,$1); string s1=string($1); tvalues[tcount]=s1;  cout<<"t"<<tcount++<<" = "<<$$<<endl; } 
 | ID { strcpy($$,$1); string s1=string($1);tvalues[tcount]=s1; cout<<"t"<<tcount++<<" = "<<$$<<endl; }
 | SUB ival {string s1($2), s2 ="-"; s2=s2+s1; tvalues[tcount]=s2; strcpy($$,(s2.c_str())); cout<<"t"<<tcount++<<" = "<<s2<<endl; }
 ;


initialisation : ID '=' ival ';' { intialiseValue($1, $3);}
 | ID '=' bval ';' { intialiseValue($1, $3);}
 ;
declarations: datatype SPACE identifier ';' {  struct variable temp; string st($1);temp.type=st; string st1($3);temp.name=st1; temp.value = ""; table.push_back(temp); }
 ;
datatype : types {strcpy($$,$1);}
 ;
identifier : ID {strcpy($$,$1);}
 ;
%%

int main(int argc, char **argv)
{
 yyparse();
}

void yyerror(char *s)
{
 fprintf(stderr, "error: %s\n", s);
}

void printTable()
{
 cout<<"\nPrinting Table\n";
 for(int i=0; i<table.size(); i++){
  cout<<table[i].type<<" "<<table[i].name<<" "<<table[i].value<<endl;
 } 
}

void intialiseValue(char* s1, char* s2)
{
 string id(s1), val(s2);
 int i;
 for(i=0; i<table.size(); i++){
  if(id.compare(table[i].name) == 0) break;
 } 
 if(table[i].type == "int" && (val=="true"|val=="false"))
  {cout<<"isyntax error\n"; exit(0);}
 else if(table[i].type == "bool" && (val!="true"&&val!="false"))
  {cout<<"bsyntax error\n"; exit(0);}
 table[i].value = val;
}

int findVal(char* s)
{
 string id(s); int i;
 for(i=0; i<table.size(); i++){
  if(id.compare(table[i].name) == 0) break;
 }
 if(table[i].value == "")
  {cout<<"vsyntax error\n"; exit(0);}  
 return atoi((table[i].value).c_str());
}

int powe(int a,int b)
{
	int ans=1,i;
	for(i=1;i<=b;i++)
	{
	ans=ans*a;
	}
	return ans;
}

string threeAddress(char* a1, char* a2, string symbol){
  int c1,c2;
  string s1(a1), s2(a2);
  for(map<int, string> ::iterator itr = tvalues.begin(); itr!=tvalues.end(); itr++){
    if(itr->second == s1) c1 = itr->first;
    if(itr->second == s2) c2 = itr->first;
  }
  string s3 = s1;
  s3+= symbol;
  s3+= s2;
  tvalues[tcount]=s3;
  cout<<"t"<<tcount++<<" = t"<<c1<<symbol<<"t"<<c2<<endl;
  return s3;
}

string threeAddress(char* a1, string symbol){
  int c1;
  string s1(a1);
  for(map<int, string> ::iterator itr = tvalues.begin(); itr!=tvalues.end(); itr++){
    if(itr->second == s1) c1 = itr->first;
  }
  string s3= "";
  s3+=symbol;
  s3+= s1;
  tvalues[tcount]=s3;
  cout<<"t"<<tcount++<<" = "<<symbol<<"t"<<c1<<endl;
  return s3;
}





