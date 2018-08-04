#include <bits/stdc++.h>
#include <string>
using namespace std;

map<string,set<string> >prods;
map<string,set<string> >lrprods;
map<string,set<string> >lfprods;
set<string>nonterminals;
set<char>terminals;
map<string,set<char> >first_map;
map<string,set<char> >follow_map;
map<pair<string,char >,string >table;
string start;


void print_prods(map<string,set<string> >prods){
	for(int i=0;i<50;i++)cout<<"-";cout<<endl;
	cout<<endl<<"printing productions...\n";
	for(map<string,set<string> >::iterator it=prods.begin();it!=prods.end();it++){
		for(set<string>::iterator it1=(it->second).begin(); it1!=(it->second).end();it1++){
			cout<<it->first<<" -> "<<(*it1)<<endl;
		}
	}
	for(int i=0;i<50;i++)cout<<"-";cout<<endl;
}


void leftrec(){

	for(map<string,set<string> >::iterator it=prods.begin();it!=prods.end();it++){
		
		set<string>lr;set<string>nlr;int c=0;//cout<<it->first<<endl;
		for(set<string>::iterator it1=(it->second).begin(); it1!=(it->second).end();it1++){
			//cout<<(*it1)<<endl;
			if((*it1).substr(0,(it->first).length())==it->first){
				lr.insert((*it1).substr((it->first).length(),(*it1).length()));c++;
			}
			else{
				nlr.insert((*it1));
			}
		}

		if(c){
			
			for(set<string>::iterator it1=lr.begin();it1!=lr.end();it1++){
				lrprods[(it->first) + "'"].insert((*it1) + (it->first) + "'");
			}
			for(set<string>::iterator it1=nlr.begin();it1!=nlr.end();it1++){
				lrprods[it->first].insert((*it1) + (it->first) + "'");
			}

			lrprods[(it->first) + "'"].insert("^");
		}

		else{

			for(set<string>::iterator it1=nlr.begin();it1!=nlr.end();it1++){
				lrprods[it->first].insert((*it1));
			}
		}
		
	}
}

void leftfac(){
	map<string,set<string> >temp1,temp = lrprods;
	string prefix;
	int i=0;
	for(map<string,set<string> >::iterator it=temp1.begin();it!=temp1.end();it++){
		string alt = it->first ;
		alt.append("'");
		for(set<string>::iterator it1=(it->second).begin(); it1!=(it->second).end();it1++){
			string s = *it1;
			for(i=0;i<s.length(); i++){
				if(s.substr(0,i) == *it1)
				{
					temp[alt].insert(s.substr(i,s.length()-1));
				}
			}
			temp[it->first].clear();
			temp[it->first].insert(prefix+alt);
		}
	}
	lfprods = lrprods;
}

void initialisesymbols(){
	for(map<string,set<string> >::iterator it=lfprods.begin();it!=lfprods.end();it++){
		nonterminals.insert(it->first);
		for(set<string>::iterator it1=(it->second).begin(); it1!=(it->second).end();it1++){
			for(int i=0;(*it1)[i];i++)
				if((*it1)[i]<'A'||(*it1)[i]>'Z'){
					terminals.insert((*it1)[i]);
				}
		}
	}
}



bool first(string symbol,set<char>&terms){
	bool nullable=false;

	int i=0;while(symbol[++i]&&symbol[i]=='\'');
	//cout<<symbol<<" "<<i<<endl;
	if(symbol[0]<'A'||symbol[0]>'Z'){
		terms.insert(symbol[0]);
	}
	else if(i==symbol.length()){

		for(map<string,set<string> >::iterator it=lfprods.begin();it!=lfprods.end();it++){
			if(it->first==symbol){
				for(set<string>::iterator it1=(it->second).begin(); it1!=(it->second).end();it1++){
					first((*it1),terms);
				}
			}
		}

	}
	else{
		i=0;
		while(symbol[i]){
			string nont = "";
			nont+=symbol[i++];
			while(symbol[i]&&symbol[i]=='\''){
				nont+="'";i++;
			}
			nont[i]='\0';
			//cout<<"nont="<<nont<<endl;
			if(first(nont,terms)){
				nullable=true;continue;
			}
			break;
		}
		if(nullable){
			terms.insert('^');
		}
	}

	return nullable;
}


void follow(){


	for(map<string,set<string> >::iterator it=lfprods.begin();it!=lfprods.end();it++){
		for(set<string>::iterator it1=(it->second).begin(); it1!=(it->second).end();it1++){
			vector<string>symbols;
			int i=0;string symbol = (*it1);
			while(symbol[i]){
				string nont = "";
				nont+=symbol[i++];
				while(symbol[i]&&symbol[i]=='\''){
					nont+="'";i++;
				}
				nont[i]='\0';
				symbols.push_back(nont);
			}
			for(vector<string>::iterator it2=symbols.begin();it2!=symbols.end();it2++){
				if((*it2)[0]<'A'||(*it2)[0]>'Z')continue;
				vector<string>::iterator it3;
				for(it3=(it2+1);it3!=symbols.end();it3++){
					bool nullable = false;
					for(set<char>::iterator it4=(first_map[*it3]).begin();it4!=(first_map[*it3]).end();it4++){
						
						if(*it4!='^'){
							follow_map[(*it2)].insert(*it4);
						}
						else{
							nullable = true;
						}
						
					}
					if(!nullable)break;
				}

				if(it3 == symbols.end()){
					for(set<char>::iterator it6=(follow_map[it->first]).begin();it6!=(follow_map[it->first]).end();it6++){
						follow_map[(*it2)].insert(*it6);
					}
				}
			}
		}
	}

}

void compute_table(){

	for(map<string,set<string> >::iterator it=lfprods.begin();it!=lfprods.end();it++){
		for(set<string>::iterator it1=(it->second).begin(); it1!=(it->second).end();it1++){
			set<char>terms;
			first((*it1),terms);
			for(set<char>::iterator it2=(terms).begin();it2!=(terms).end();it2++){
						
				if(*it2=='^'){
					for(set<char>::iterator it3=(follow_map[it->first]).begin();it3!=(follow_map[it->first]).end();it3++){
						table[make_pair(it->first,*it3)] = *it1;
					}
				}
				else{
					table[make_pair(it->first,*it2)] = *it1;
				}
						
			}
		}
	}

}

void print_table(){
	for(int i=0;i<50;i++)cout<<"-";cout<<endl;

	for(map<pair<string,char >,string >::iterator it=table.begin();it!=table.end();it++){
		cout<<"m["<<(it->first).first<<","<<(it->first).second<<"] => "<<(it->first).first<<"->"<<it->second<<endl;
	}

	for(int i=0;i<50;i++)cout<<"-";cout<<endl;
}

void parse(string input){

	input+="$";
	stack<string>stk;
	stk.push(start);
	int k=0;
	while(input[k]){
		if(k==input.length() || (stk.top())[0]=='$')
		{
			cout<<"parsing complete\n";
			break;
		}
		if(stk.size()<=0){
			cout<<"Failed\n";return;
		}
		if(stk.top()[0]==input[k]){
			cout<<"match and pop "<<input[k]<<endl;
			k++;stk.pop();continue;
		}
		
		if(table.find(make_pair(stk.top(),input[k]))==table.end()){
			cout<<"Failed: not found in table "<<stk.top()<<"->"<<input[k]<<endl;return;
		}
		

		string right = table[make_pair(stk.top(),input[k])];
		cout<<stk.top()<<"->"<<right<<endl;
		
		if(right[0]=='^'){
			cout<<stk.top()<<"->"<<"^"<<endl;
			stk.pop();
			if(stk.size()==0&&input[k]=='$'){
				cout<<"String present in the language\n";break;
			}
			continue;
		}
		stk.pop();
		if(stk.size()==0&&input[k]=='$'){
			cout<<"String present in the language\n";return;
		}
		vector<string>symbols;
			int i=0;string symbol = right;
			while(symbol[i]){
				string nont = "";
				nont+=symbol[i++];
				while(symbol[i]&&symbol[i]=='\''){
					nont+="'";i++;
				}
				nont[i]='\0';
				symbols.push_back(nont);
			}

		for(vector<string>::reverse_iterator it=symbols.rbegin();it!=symbols.rend();it++){
			stk.push(*it);
		}

	}
	if(!stk.empty())
	cout<<"Failed : Stack not empty";


}


int main(){

	cout<<"Enter Start Symbol:";
	cin>>start;
	follow_map[start].insert('$');

	cout<<"Enter productions S -> AB(! to exit):\n";
	while(1){
		string head;
		cin>>head;if(head=="!")break;
		string body;
		cin>>body>>body;
		prods[head].insert(body);
	}

	print_prods(prods);
	leftrec();
	print_prods(lrprods);
	leftfac();
	print_prods(lfprods);

	initialisesymbols();



	for(set<string>::iterator it=nonterminals.begin();it!=nonterminals.end();it++){
		set<char>terms;
		first(*it,terms);
		cout<<"First of "<<(*it)<<": ";
		for(set<char>::iterator it1=terms.begin();it1!=terms.end();it1++){
			cout<<(*it1)<<",";
			first_map[*it].insert(*it1);
		}
		cout<<endl;
	}

	for(set<char>::iterator it=terminals.begin();it!=terminals.end();it++){
		set<char>terms;string allow="x";allow[0]=*it;
		first(allow,terms);
		cout<<"First of "<<(*it)<<": ";
		for(set<char>::iterator it1=terms.begin();it1!=terms.end();it1++){
			cout<<(*it1)<<",";
			first_map[allow].insert(*it1);
		}
		cout<<endl;
	}
	cout<<endl;

	for(int i=0;i<50;i++)cout<<"-";cout<<endl;

	follow();follow();


	for(map<string,set<char> >::iterator it=follow_map.begin();it!=follow_map.end();it++){
		cout<<"follow of "<<it->first<<" is: ";
		for(set<char>::iterator it1=(it->second).begin();it1!=(it->second).end();it1++){
			cout<<(*it1)<<",";
		}
		cout<<endl<<endl;
	}

	for(int i=0;i<50;i++)cout<<"-";cout<<endl;


	compute_table();
	print_table();
	while(1){

		cout<<"Enter string to validate:\n";
		string input;cin>>input;
		parse(input);

	}


	return 0;
}

