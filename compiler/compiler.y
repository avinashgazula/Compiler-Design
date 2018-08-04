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
string threeAddress(char*, char*, string);
string threeAddress(char*, string);
void threeAddressSelf(char*, char*, string);
void checkID(char*);


int tcount=0, label_count=0, d=0, s_count=0;
string result = "", bresult = "";
map<int, string> tvalues;
vector<int> repeat;
stack<int> s;
%}
%union 
{
        int number;
        char str[100];
}
%token <str> types ID RELOP ival bval WHILE boolValue IF ELSE SWITCH BREAK DEFAULT CASE
%token <number> intVal
%token ADD SUB MUL DIV ABS NEG  BAND BOR 
%left AND OR XOR
%right POW
%type <str> declarations datatype identifier initialisation 
%type <str> eval bitor bitxor bitand exp factor powterm term bitneg 
%type <str> booleval bool_and bool_not bool_rel 
%nonassoc ELSE IFX 

%%
S: 
 | S declarations  {/*printTable();*/}
 | S initialisation  {/*printTable();*/}
 | S eval  {cout<<result<<endl; result =""; /*printTable();*/; tcount =0; tvalues.clear();} 
 | S booleval  {cout<<bresult<<endl; result ="";tcount =0; tvalues.clear();}
 | S boolassign  {cout<<bresult<<endl; result ="";tcount =0; tvalues.clear();}
 | S cond_while {}
 | S cond_if {}
 | S cond_if_else {}
 | S cond_switch {}
 | '{' S '}' {}
 ;

cond_while: WHILE '(' M1 booleval M2 ')'  '{' S M3 '}' {cout<<"mid"<<s.top()<<":"<<endl;s.pop();d++;tvalues.clear();}
 ;
cond_if: IF '(' M1 booleval M2 ')' '{' S '}' %prec IFX	{	cout<<"mid"<<s.top()<<":"<<endl;s.pop();}
;
cond_if_else: IF '(' M1 booleval M2 ')' '{' S '}' M4 ELSE M5 '{' S '}'	{cout<<"end"<<s.top()<<":"<<endl;s.pop();	}
;
M1:	{cout<<"start"<<label_count<<":\n";s.push(label_count);label_count++;}
;
M2:	{cout<<"jump !t"<<tcount-1<<" "<<"mid"<<s.top()<<endl;}
;
M3:	{cout<<"jump start"<<s.top()<<"\n";}
;
M4:	{cout<<"jump end"<<s.top()<<"\n";}
;
M5:	{cout<<"mid"<<s.top()<<":\n";}
;
cond_switch:	SWITCH '(' booleval M11 ')' '{' cases '}'	{ cout<<"last:"<<s_count<<endl;s_count++;}
;
cases:	
|	M44 CASE booleval ':' M22 S BREAK M33 ';' cases	{}
|	DEFAULT ':' S	{}
;
M11:	{cout<<"k=t"<<tcount-1<<endl;}
;
M22:	{cout<<"jump !k==t"<<tcount-1<<" end"<<s.top()<<endl;}
;
M33:	{cout<<"jump last"<<s_count<<"\n";cout<<"end"<<s.top()<<":"<<endl;s.pop();}
;
M44:	{cout<<"start"<<label_count<<":\n";s.push(label_count);label_count++;}
;
boolassign: ID '=' booleval ';'{ checkID($1); 
    int c1;
    string s1($3);
    for(map<int, string> ::iterator itr = tvalues.begin(); itr!=tvalues.end(); itr++){
      if(itr->second == s1) c1 = itr->first;
    }
    cout<<$1<<" = t"<<c1<<endl;
	}
 ;
booleval:bool_and
 | booleval BOR bool_and { strcpy($$,((threeAddress($1, $3, "||")).c_str())); }
 ;
bool_and:bool_not
 | bool_and BAND bool_not {strcpy($$,((threeAddress($1, $3, "&&")).c_str()));}
 ; 
bool_not:bool_rel
 | '!' bool_not {
       strcpy($$,((threeAddress($2, "!")).c_str()));} 
 ;
bool_rel:bval{strcpy($$,$1); string s1=string($1); tvalues[tcount]=s1;  cout<<"t"<<tcount++<<" = "<<$$<<endl;}
 | term RELOP term { string relop($2); strcpy($$,((threeAddress($1, $3, relop)).c_str()));}
 | term {strcpy($$,$1);}
 ;
eval: ID '=' exp ';'{ checkID($1); 
    int c1;
    string s1($3);
    for(map<int, string> ::iterator itr = tvalues.begin(); itr!=tvalues.end(); itr++){
      if(itr->second == s1) c1 = itr->first;
    }
    cout<<$1<<" = t"<<c1<<endl;
    repeat.clear();
	}
  | ID ADD '=' exp ';'{ checkID($1); 
    threeAddressSelf($1,$4," + ");
	}
  | ID SUB '=' exp ';'{ checkID($1); 
    threeAddressSelf($1,$4," - ");
	}
  | ID MUL '=' exp ';'{ checkID($1); 
    threeAddressSelf($1,$4," * ");
	}
  | ID DIV '=' exp ';'{ checkID($1); 
    threeAddressSelf($1,$4," / ");
	}
  | ID POW '=' exp ';'{ checkID($1); 
    threeAddressSelf($1,$4," @ ");
	}
 ;
exp: factor
 | exp ADD factor { 
  strcpy($$,((threeAddress($1, $3, "+")).c_str()));}
 | exp SUB factor { 
  strcpy($$,((threeAddress($1, $3, "-")).c_str()));}
 ;
factor: powterm 
 | factor MUL powterm { 
  strcpy($$, ((threeAddress($1, $3, "*")).c_str()));}
 | factor DIV powterm { 
  strcpy($$,((threeAddress($1, $3, "/")).c_str()));}
 ;
powterm:bitor
  | bitor POW powterm { 
  strcpy($$,((threeAddress($1, $3, "@")).c_str()));
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
   | bitand AND bitneg { 
  strcpy($$,((threeAddress($1, $3, "&")).c_str()));}
   ;
bitneg:term
   | NEG bitneg {
       strcpy($$,((threeAddress($2, "~")).c_str()));} 
   ;
term: ival { strcpy($$,$1); string s1=string($1); tvalues[tcount]=s1;  cout<<"t"<<tcount++<<" = "<<$$<<endl; /*stringstream ss;ss<<tcount; result+="t"+ss.str()+" = "+string($$)+"\n"; tcount++;*/ } 
 | ID { checkID($1);strcpy($$,$1); string s1=string($1);tvalues[tcount]=s1; cout<<"t"<<tcount++<<" = "<<$$<<endl; /*stringstream ss;ss<<tcount; result+="t"+ss.str()+" = "+s1+"\n"; tcount++;*/ }
 | SUB ival {string s1($2), s2 ="-"; s2=s2+s1; tvalues[tcount]=s2; strcpy($$,(s2.c_str())); cout<<"t"<<tcount++<<" = "<<$$<<endl; /*stringstream ss;ss<<tcount; result+="t"+ss.str()+" = "+s2+"\n"; tcount++;*/ }
 | '(' exp ')' {strcpy($$,$2);}
 ;
initialisation: ID '=' ival ';' { checkID($1); intialiseValue($1, $3);}
 | ID '=' bval ';' { checkID($1); intialiseValue($1, $3);}
 ;
declarations: datatype identifier ';' {  struct variable temp; string st($1);temp.type=st; string st1($2);temp.name=st1; temp.value = ""; table.push_back(temp); }
 ;
datatype: types {strcpy($$,$1);} 
 ;
identifier: ID {strcpy($$,$1);}
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

//Function for printing Symbol Table
void printTable()
{
 //cout<<"\nPrinting Table\n";
 for(int i=0; i<table.size(); i++){
  cout<<table[i].type<<" "<<table[i].name<<" "<<table[i].value<<endl;
 } 
}

//Function for intialising values to variables Ex:a=6, b=true
void intialiseValue(char* s1, char* s2)
{
 string id(s1), val(s2);
 int i;
 for(i=0; i<table.size(); i++){
  if(id.compare(table[i].name) == 0) break;
 } 
 //Checking if the initialised variable has been declared
 if(i==table.size()){
   cout<<id<<" not declared\n"; exit(0);
 }
 //Generating an error if an int is assigned a boolean value
 if(table[i].type == "int" && (val=="true"|val=="false"))
  {cout<<"isyntax error\n"; exit(0);}
//Generating an error if a bool is assigned an integer value
 else if(table[i].type == "bool" && (val!="true"&&val!="false"))
  {cout<<"bsyntax error\n"; exit(0);}
 table[i].value = val;
 cout<<"t"<<tcount++<<" = "<<val<<endl;
 cout<<id<<" = t"<<tcount-1<<endl;
}

//function for checking if the variable used has been declared
void checkID(char* a1){
  string id(a1);
 int i;
 //Checking the symbol table for the variable
 for(i=0; i<table.size(); i++){
  if(id.compare(table[i].name) == 0) break;
 } 
 if(i==table.size()){
   cout<<id<<" not declared\n"; exit(0);
 }
}


//Function for generating three address code for the evaulation of a1 *symbol* a2 Ex: 2+3
string threeAddress(char* a1, char* a2, string symbol){
  int c1=-1,c2=-1;
  string s1(a1), s2(a2);
  for(map<int, string> ::iterator itr = tvalues.begin(); itr!=tvalues.end(); itr++){
    if(itr->second == s1 && find(repeat.begin(), repeat.end(),itr->first )==repeat.end()&&c1==-1) {c1 = itr->first;repeat.push_back(c1);}
    if(itr->second == s2 && find(repeat.begin(), repeat.end(),itr->first)==repeat.end()&& c2==-1) {c2 = itr->first;repeat.push_back(c2);}
  }
  
  string s3 = s1;
  s3+= symbol;
  s3+= s2;
  tvalues[tcount]=s3;
  cout<<"t"<<tcount++<<" = t"<<c1<<symbol<<"t"<<c2<<endl;
  return s3;
}

//Function for generating three address code for the evaulation of *symbol* a1 Ex: ~9
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

//Function for generating three address code for the evaulation of a1 *symbol*= a2 Ex: a+=2;
void threeAddressSelf(char* a1, char*a2, string symbol){
    int c1;
    string s(a1),s1(a2);
    for(map<int, string> ::iterator itr = tvalues.begin(); itr!=tvalues.end(); itr++){
      if(itr->second == s1) c1 = itr->first;
    }
    cout<<"t"<<tcount<<" = "<<s<<"\n";
    cout<<s<<" = t"<<c1<<symbol<<"t"<<tcount++<<"\n";
}