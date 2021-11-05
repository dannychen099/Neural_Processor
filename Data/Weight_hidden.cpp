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
	ifstream fin("Weigth_hidden.dat");
	string line;
	int cnt = 0;
	vector <string> w;
	while (getline(fin, line))
	{
		int num = get(line[1]) + 16 * get(line[0]);
		string s = "";
		for (int i = 7 ; i >= 0 ; i--)
			if ((1 << i) & num)
				s += "1";
			else
				s += "0";
		if ((cnt + 1) % 62 == 0)
		{
			cout << "assign weigth_hidden" + to_string(cnt / 62) << " = 496'b";
			for (int i = w.size() - 1 ; i >= 0 ; i--)
				if (i != 0)
					cout << w[i] << "_";
				else
					cout << w[i] << ";";
			cout << endl;
			w.clear();
		}
		cnt++;
	}
}