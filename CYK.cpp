#include <bits/stdc++.h>
using namespace std;
struct pro1 // Productions of the type A->BC
{
    char a;
    char b;
    char c;
};
struct pro2 // Productions of the type A->a
{
    char x;
    char y;
};
vector<char> variables; // contains all variables of the grammar
vector<char> terminals; // contains all terminals of the grammar
vector<pro1> vec1;		//All productions of the type A->BC
vector<pro2> vec2;		//All productions of the type A->a
char start;				//start symbol

void print_arr(set<char> **, int); //prints table
bool is_valid(string);			   //checks if string belongs to grammar
bool CYK(string);
set<char> get_set(char);						//get the bottom row of the table
set<char> get_set(set<char> **, int, int, int); //get the rest of the table
void print_pro();								//Prints all the productions of the grammar

int main()
{
    string str;
    ifstream fin;
    fin.open("productions.txt");
    if (!fin)
    {
        cout << "error opening file\n";
        exit(0);
    }
    fin >> start; //first line of the file specifies the start symbol
    variables.clear();
    terminals.clear();
    vec1.clear();
    vec2.clear();
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
    //inserting productions into vec1 for A->BC and into vec2 for A->a
    while (fin >> str)
    {
        if (str.length() == 3)
        {
            pro1 obj1;
            obj1.a = str[0];
            obj1.b = str[1];
            obj1.c = str[2];
            vec1.push_back(obj1);
        }
        else if (str.length() == 2)
        {
            pro2 obj2;
            obj2.x = str[0];
            obj2.y = str[1];
            vec2.push_back(obj2);
        }
        else
        {
            cout << "Invalid production in input\n";
            exit(0);
        }
    }
    print_pro();
    cout << "enter a input string : ";
    cin >> str;
    if (is_valid(str))
    {
        if (CYK(str))
        {
            cout << "The given string is a member of CFG\n";
        }
        else
        {
            cout << "The given string is not a member of CFG\n";
        }
    }
    else
    {
        cout << "The given string is not a member of CFG\n";
    }
    return 0;
}
void print_pro() //Printing all the productions given as input
{
    for (int i = 0; i < vec1.size(); i++)
    {
        cout << vec1[i].a << "---->" << vec1[i].b << vec1[i].c << "\n";
    }
    for (int i = 0; i < vec2.size(); i++)
    {
        cout << vec2[i].x << "---->" << vec2[i].y << "\n";
    }
}
bool is_valid(string str) //check if all the characters of input string are terminals of the language
{
    for (int i = 0; i < str.length(); i++)
    {
        bool x = false;
        for (int j = 0; j < terminals.size(); j++)
        {
            if (terminals[j] == str[i])
            {
                x = true;
                break;
            }
        }
        if (!x)
            return false;
    }
    return true;
}
bool CYK(string str)
{
    int n = str.length();
    set<char> **arr; //array arr represents the table
    arr = new set<char> *[n];
    for (int i = 0; i < n; i++)
    {
        arr[i] = new set<char>[n];
    }
    for (int i = 0; i < n; i++) //filling the bottom row
    {
        arr[n - 1][i] = get_set(str[i]);
    }
    int ab = n - 1;
    for (int i = n - 2; i >= 0; i--)
    {
        for (int j = 0; j < ab; j++)
        {
            arr[i][j] = get_set(arr, i, j, n);
        }
        ab--;
    }
    print_arr(arr, n);
    return (arr[0][0].find(start)) != (arr[0][0].end());
}
void print_arr(set<char> **arr, int n)
{
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j <= i; j++)
        {
            set<char>::iterator itr;
            cout << "{";
            for (itr = arr[i][j].begin(); itr != arr[i][j].end(); itr++)
            {
                cout << *itr << ",";
            }
            cout << "}";
            cout << "   ";
        }
        cout << "\n";
    }
}
set<char> get_set(char ch) // fill the bottom row of the table
{
    set<char> x;
    x.clear();
    for (int i = 0; i < vec2.size(); i++)
    {
        if (vec2[i].y == ch)
            x.insert(vec2[i].x);
    }
    return x;
}
set<char> get_set(set<char> **arr, int ind, int jnd, int n) // fill the remaining rows of the table
{
    int xi = ind + 1, yi = jnd + 1;
    set<char> ans;
    ans.clear();
    for (int p = n - 1; p > ind; p--)
    {
        set<char>::iterator itr1;
        set<char>::iterator itr2;
        for (itr1 = arr[p][jnd].begin(); itr1 != arr[p][jnd].end(); itr1++)
        {
            for (itr2 = arr[xi][yi].begin(); itr2 != arr[xi][yi].end(); itr2++)
            {
                char ch1 = *itr1;
                char ch2 = *itr2;
                for (int i = 0; i < vec1.size(); i++)
                {
                    if (vec1[i].b == ch1 && vec1[i].c == ch2)
                    {
                        ans.insert(vec1[i].a);
                    }
                }
            }
        }
        xi++;
        yi++;
    }
    return ans;
}
