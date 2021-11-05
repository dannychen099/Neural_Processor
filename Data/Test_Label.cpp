#include <bits/stdc++.h>
using namespace std;

int get(char c)
{
	if (c >= '0' && c <= '9')
		return c - '0';
	return c - 'A' + 10;
}

int main()
{
	ifstream fin("Test_Label.dat");
	string line;
	int cnt = 0;
	vector <string> w;
	while (getline(fin, line))
	{
		int num = line[0] - '0';		
		string s = "";
		for (int i = 3 ; i >= 0 ; i--)
			if ((1 << i) & num)
				s += "1";
			else
				s += "0";
		cout << s << endl;
		cnt++;
	}
}