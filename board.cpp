#include<iostream>
#include<vector>
using namespace std;


vector<vector<int>> board(9, vector<int>(9, 0));

void setValuesVector(vector<int> &values)
{
    values.clear();
    for(int i=1;i<=9;i++)
        values.push_back(i);
}

bool isValidNumberForCurrentCell(int r, int c, int num)
{
    for(int i=0;i<r;i++)  
        if( board[i][c]==num)
            return false;
    
    for(int j=0;j<c;j++)  
        if( board[r][j]==num)
            return false;
    
    int x=3* (r/3);  //start semibox row
    int y=3*(c/3);   //start semibox column

    for(int i=x; i<=r;i++)
        for(int j=y;j<y+3;j++)
           { 
            if(i==r and j==c)
                continue;
            if(board[i][j]==num)
                return false;
            }

    return true;
    
}


void setValue(int r, int c, int value)
{
    board[r][c]=value; 
}


void displayBoard();

int count=1;

void makeValid(int x, int y)
{


    if(y>8)
        x++, y=0;
  
    if(x>8)
    {
        displayBoard();
        cout<<endl<<count<<endl;
        exit(0);

    }

   for(int i=1;i<=9;i++)
    {
        count++;
        if(isValidNumberForCurrentCell(x,y,i))
        {
            setValue(x,y,i);
            makeValid(x,y+1);
        }
    }

}


void displayBoard()
{

    cout<<"\n\n";
    for(int i=0;i<board.size();i++)
    {
        for(int j=0; j<9;j++)
        {
            cout<<board[i][j]<<" ";
        }
        cout<<endl;
    }

}

int main()
{

    srand(time(0));
    vector<int> values ={1,2,3,4,5,6,7,8,9};


    ///set first row with random values from 1-9 using values vector and random function

    for(int i=0;i<9;i++)
    {
        int x= rand() % values.size();
        board[0][i]=values[x];
        values.erase(values.begin()+x);
    }

    setValuesVector(values);


    makeValid(1,0);

    
    // displayBoard();

    // cout<<endl<<count<<endl;


    return 0;
}