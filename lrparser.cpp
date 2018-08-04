#include <bits/stdc++.h>
#include <unistd.h>
using namespace std;
vector<char> variables;         // contains all variables of the grammar
vector<char> terminals;         // contains all terminals of the grammar
map<char, vector<string>> prod; //contains productions
char start;                     //start symbol
int noStates = 0;

struct closure
{
    char left;
    string right;
    int dot;
};

map<int, closure> reduceNumbers;
map<int, vector<closure>> states;
map<int, map<char, int>> go_to;

void print_pro(); //Prints all the productions of the grammar

bool isVariable(char);

void closureProd(vector<closure> &first)
{

    for (int i = 0; i < first.size(); i++)
    {
        //cout<<" size "<<first.size()<<endl;
        if (first[i].dot == first[i].right.length())
            continue;

        char next = first[i].right[first[i].dot];
        for (map<char, vector<string>>::iterator itr = prod.begin(); itr != prod.end(); itr++)
        {

            if (itr->first == next)
            {
                vector<string> right(itr->second);
                for (int i = 0; i < right.size(); i++)
                {
                    closure temp;
                    temp.left = next;
                    temp.right = right[i];
                    temp.dot = 0;
                    bool present = false;
                    for (vector<closure>::iterator it = first.begin(); it != first.end(); it++)
                    {
                        closure temp1 = *it;

                        if (temp.left == temp1.left && temp.right == temp1.right && temp.dot == temp1.dot)
                        {
                            present = true;
                            //cout<<"present\n";
                            //sleep(2);
                        }
                    }
                    if (!present)
                        first.push_back(temp);
                }
            }
        }
    }
}

int main(int argc, char const *argv[])
{
    string str;
    ifstream fin;
    fin.open("grammar.txt");
    if (!fin)
    {
        cout << "error opening file\n";
        exit(0);
    }
    fin >> start; //first line of the file specifies the start symbol
    variables.clear();
    terminals.clear();
    fin >> str;
    for (int i = 0; i < str.length(); i++)
    {
        variables.push_back(str[i]); //second line of file specifies all the variables
    }
    fin >> str;
    for (int i = 0; i < str.length(); i++)
    {
        terminals.push_back(str[i]); //third line of file specifies all the terminals
    }
    while (fin >> str)
    {
        char left = str[0];
        if (find(variables.begin(), variables.end(), left) == variables.end())
        {
            cout << "Wrong input\n";
            return 0;
        }
        bool present = false;
        std::vector<string> temp;
        map<char, vector<string>>::iterator mitr = prod.find(left);
        if (mitr != prod.end())
        {
            present = true;
            vector<string> vtemp(mitr->second);
            for (int i = 0; i < vtemp.size(); i++)
                temp.push_back(vtemp[i]);
            vtemp.clear();
        }

        char right[10];
        memset(right, 0, 10);
        int ptr = 0;

        for (int i = 1; i < str.length(); i++)
        {
            if (str[i] == '|' || i == str.length() - 1)
            {
                if (i == str.length() - 1)
                {
                    right[ptr++] = str[i];
                }
                ptr = 0;
                string stemp(right);
                temp.push_back(stemp);
                memset(right, 0, 10);
            }
            else
            {
                right[ptr++] = str[i];
            }
        }
        prod[left] = temp;
        temp.clear();
    }
    print_pro();

    cout << "hello1\n";

    closure closure_start;
    closure_start.left = 'Z';
    closure_start.right = start;
    closure_start.dot = 0;

    vector<closure> first;
    first.push_back(closure_start);
    closureProd(first);

    cout << "hello2\n";

    cout << endl
         << endl;
    for (int i = 0; i < first.size(); i++)
    {
        closure temp = first[i];
        cout << temp.left << " -> ";
        for (int i = 0; i < temp.dot; i++)
        {
            cout << temp.right[i];
        }
        cout << ".";
        for (int i = temp.dot; i < temp.right.size(); i++)
        {
            cout << temp.right[i];
        }
        cout << endl;
    }

    cout << "hello3\n";

    int stateCount = 0;
    states[noStates++] = first;

    int zcount = 0;
    for (map<int, vector<closure>>::iterator itr = states.begin(); itr != states.end(); itr++)
    {

        cout << "\n\nState I" << zcount++ << endl;

        vector<closure> state = itr->second;
        for (int i = 0; i < state.size(); i++)
        {
            closure temp = state[i];
            cout << temp.left << " -> ";
            for (int i = 0; i < temp.dot; i++)
            {
                cout << temp.right[i];
            }
            cout << ".";
            for (int i = temp.dot; i < temp.right.size(); i++)
            {
                cout << temp.right[i];
            }
            cout << endl;

            //REDUCE
            //cout << "\n\ndot " << temp.dot << endl;
            //cout << "right size " << temp.right.size() << endl;

            if (temp.dot == temp.right.size())
            {
                //cout << " in reduce\n";
                for (int z = 0; z < terminals.size(); z++)
                {
                    cout << "action table[" << zcount - 1 << "][" << terminals[z] << "] = R";

                    for (map<int, closure>::iterator ritr = reduceNumbers.begin(); ritr != reduceNumbers.end(); ritr++)
                    {
                        closure test = ritr->second;
                        if (test.left == temp.left && test.right == temp.right && temp.dot == test.dot)
                            cout << ritr->first << endl;
                    }
                }
            }

            cout << endl;
        }

        map<char, vector<closure>> tempMap;
        for (int i = 0; i < state.size(); i++)
        {
            char next = state[i].right[state[i].dot];

            closure nextState;
            nextState.left = state[i].left;
            nextState.right = state[i].right;
            nextState.dot = state[i].dot + 1;

            vector<closure> first;
            first.push_back(nextState);

            //cout<<"states "<<noStates<<endl;
            if (tempMap.find(next) == tempMap.end())
            {
                //cout<<endl<<i+1<<" not found\n";
                closureProd(first);
                tempMap[next] = first;
            }

            else
            {

                //cout<<endl<<i+1<<" found\n";
                vector<closure> tempVec = (tempMap.find(next))->second;
                for (int l = 0; l < first.size(); l++)
                    tempVec.push_back(first[l]);
                closureProd(tempVec);
                tempMap[next] = tempVec;
            }
        }

        for (map<char, vector<closure>>::iterator mitr = tempMap.begin(); mitr != tempMap.end(); mitr++)
        {

            if (mitr->first != '\0')
            {

                //cout<<"\n\ngoto(I"<<stateCount<<","<<mitr->first<<") is ";

                vector<closure> checkState1 = mitr->second;
                bool present = false;
                int xcount = 0;
                for (map<int, vector<closure>>::iterator citr = states.begin(); citr != states.end(); citr++)
                {
                    vector<closure> checkState2 = citr->second;
                    if (checkState1.size() == checkState2.size())
                    {
                        int checkCount = 0;
                        for (int y = 0; y < checkState1.size(); y++)
                        {
                            if (checkState1[y].dot == checkState2[y].dot && checkState1[y].left == checkState2[y].left && checkState1[y].right == checkState2[y].right)
                            {
                                checkCount++;
                            }
                        }
                        if (checkCount == checkState1.size())
                        {
                            //cout<<"\t is I"<<xcount<<endl;

                            if (isVariable(mitr->first))
                                cout << "goto table[" << stateCount << "][" << mitr->first << "] = " << xcount << endl;
                            else
                                cout << "action table[" << stateCount << "][" << mitr->first << "] = S" << xcount << endl;

                            present = true;
                        }
                    }
                    xcount++;
                }

                if (!present)
                {
                    states[noStates++] = mitr->second;
                    //cout<<"\t is I"<<noStates-1<<endl;

                    //PRINTING STATES
                    /*
                    cout << endl
                         << endl;
                    for (int i = 0; i < mitr->second.size(); i++)
                    {
                        closure temp = mitr->second[i];
                        cout << temp.left << " -> ";
                        for (int i = 0; i < temp.dot; i++)
                        {
                            cout << temp.right[i];
                        }
                        cout << ".";
                        for (int i = temp.dot; i < temp.right.size(); i++)
                        {
                            cout << temp.right[i];
                        }
                        cout << endl;
                    }
                    */
                }
            }
        }
        //cout<<"next state ";
        stateCount++;
    }

    cout << "Total states : " << states.size() << " " << noStates << endl;

    return 0;
}

void print_pro() //Printing all the productions given as input
{
    int no = 0;
    for (map<char, vector<string>>::iterator itr = prod.begin(); itr != prod.end(); itr++)
    {
        cout << itr->first << " -> ";
        vector<string> right(itr->second);
        for (int i = 0; i < right.size(); i++)
        {
            closure temp;
            temp.left = itr->first;
            temp.right = right[i];
            temp.dot = right[i].length();
            reduceNumbers[no++] = temp;
            cout << right[i] << " | ";
        }
        cout << endl;
    }
}

bool isVariable(char x)
{
    for (int i = 0; i < variables.size(); i++)
    {
        if (x == variables[i])
            return true;
    }
    return false;
}
