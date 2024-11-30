#include<iostream>
#include<vector>
using namespace std;

//doing everything using 1D vector
vector<int> board(81, 0);

void setValuesVector(vector<int> &values)
{
    values.clear();
    for(int i=1;i<=9;i++)
        values.push_back(i);
}

bool isValidNumberForCurrentCell(int r, int c, int num)
{
    for(int i=0;i<r;i++)  
        if( board[i*9+c]==num)
            return false;
    
    for(int j=0;j<c;j++)  
        if( board[r*9+j]==num)
            return false;
    
    int x=3* (r/3);  //start semibox row
    int y=3*(c/3);   //start semibox column

    for(int i=x; i<=r;i++)
        for(int j=y;j<y+3;j++)
           { 
            if(i==r and j==c)
                continue;
            if(board[i*9+j]==num)
                return false;
            }

    return true;
    
}


void setValue(int r, int c, int value)
{
    board[r*9+c]=value; 
}


void displayBoard()
{

    cout<<"\n\n";
    for(int i=0;i<9;i++)
    {
        for(int j=0; j<9;j++)
        {
            cout<<board[i*9+j]<<" ";
        }
        cout<<endl;
    }

}

int count=1;

void makeValid(int x, int y)
{
    

    if(y>8)
        x++, y=0;

        displayBoard();
  
    if(x>8)
    {
        displayBoard();
        cout<<endl<<count<<endl;
        exit(0);

    }

   //vector<int> values;
   //setValuesVector(values);
    for(int i=1;i<=9;i++)
    {
            count++;
        if(isValidNumberForCurrentCell(x, y, i))
        {
            setValue(x, y, i);
            makeValid(x, y+1);
            setValue(x, y, 0);
        }
    }

}




int main()
{

    srand(time(0));
    //set first row with random values from 1-9 using values vector and random function
    vector<int> values={1,2,3,4,5,6,7,8,9};

    for(int i=0;i<9;i++)
    {
        int index=rand()%values.size();
        board[i]=values[index];
        values.erase(values.begin()+index);
    }

    setValuesVector(values);
    makeValid(1, 0);
    


    return 0;
}