//cpp code that reads file omkie.txt and prints except the comma character

#include <iostream>
#include <fstream>
#include <string>

int main()
{
	// std::ifstream file("omkie.txt");
    // std::fstream bile("o.txt", std::ios::out);

	// if (!file.is_open())
	// {
	// 	std::cerr << "Failed to open file\n";
	// 	return 1;
	// }

	// char c;
	// while (file.get(c))
	// {
	// 	if (c != '#' && c != '*'&& c != '-')
	// 	{
	// 		bile<< c;
	// 	}
	// }


	//CODE TO TAKE TWO MATRICES INPUT OF 3X3 AND DISPLAY THEIR MULTIPLICATION

	int a[3][3],b[3][3],c[3][3];

	std::cout<<"Enter the elements of first matrix\n";
	for(int i=0;i<3;i++)
	{
		for(int j=0;j<3;j++)
		{
			std::cin>>a[i][j];
		}
	}

	std::cout<<"Enter the elements of second matrix\n";

	for(int i=0;i<3;i++)
	{
		for(int j=0;j<3;j++)
		{
			std::cin>>b[i][j];
		}
	}



	for(int i=0;i<3;i++)
	{
		for(int j=0;j<3;j++)
		{
			c[i][j]=0;
			for(int k=0;k<3;k++)
			{
				c[i][j]+=a[i][k]*b[k][j];
			}
		}
	}


	std::cout<<"The resultant matrix is\n";

	for(int i=0;i<3;i++)
	{
		for(int j=0;j<3;j++)
		{
			std::cout<<c[i][j]<<" ";
		}
		std::cout<<"\n";
	}



	return 0;
}

// #include <iostream>
// #include <fstream>
// using namespace std;

// int main() {
//     ifstream inputFile("input.txt");
//     ofstream outputFile("output.txt");

//     if (!inputFile.is_open()) {
//         cout << "Error opening file!" << endl;
//         return 1;
//     }

//     string line;

//     // Read each line from the input file and write to output with a tab after each row
//     while (getline(inputFile, line)) {
//         outputFile << line << "\t"; // Write the line and append a tab after it
//     }

//     inputFile.close();
//     outputFile.close();

//     cout << "Done!" << endl;

//     return 0;
// }

// #include<iostream>
// #include<vector>
// #include<algorithm>
// using namespace std;

// int main()
// {
// 	vector<int> arr={3,6,9,10,12,15,18};

// 	sort(arr.begin(),arr.end()); //initially sort the array in ascending order as given in question

// 	//odd position in ascending order and even position in descending order

// 	for(int i=0;i<arr.size();i++)
// 	{
// 		if(i%2==1)
// 		{
// 			for(int j=i+1;j<arr.size();j++) //for odd position in ascending order
// 			{
// 				if(arr[i]<arr[j])
// 				{
// 					int temp=arr[i];
// 					arr[i]=arr[j];
// 					arr[j]=temp;
// 				}
// 			}
// 		}
// 		else
// 		{
// 			for(int j=i+1;j<arr.size();j++) //for even position in descending order
// 			{
// 				if(arr[i]>arr[j])
// 				{
// 					int temp=arr[i];
// 					arr[i]=arr[j];
// 					arr[j]=temp;
// 				}
// 			}
// 		}
// 	}


	

// 	//display the sorted array

// 	for(int i=0;i<arr.size();i++)
// 	{
// 		cout<<arr[i]<<" ";
// 	}



// 	return 0;
// }
