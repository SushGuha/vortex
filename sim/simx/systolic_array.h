#include <iostream>
#include <vector>

using namespace std;

const int ROWS = 3;  // number of rows in the systolic array
const int COLS = 2;  // number of columns in the systolic array

const int ROWS2 = 2;  // number of rows in the systolic array
const int COLS2 = 3;  // number of columns in the systolic array

// Define the processing element (PE) class
class PE {
public:
    // Constructor
    PE() {
        m_value = 0;
        l_value = 0;
        top_value = 0;
    }

    int m_value;  // value stored in the PE
    int l_value;
    int top_value;
};

// Define the systolic array class
class SystolicArray {
public:
    // Constructor
    SystolicArray() {
        // Create the processing elements
        for (int i = 0; i < ROWS; i++) {
            m_peGrid.push_back(vector<PE>());
            for (int j = 0; j < COLS2; j++) {
                m_peGrid[i].push_back(PE());
            }
        }
    }

    // Set the input values for the first row of processing elements
    void setInputs(vector<int>& inputRow, vector<int>& inputCol) {

        // Setting the first row of elements.
        for (int i = 0; i < COLS2; i++) {
            m_peGrid[0][i].top_value = (inputRow[i]);
        }

        // Setting the first column of elements.
        for (int i = 0; i < ROWS; i++) {
            m_peGrid[i][0].l_value = (inputCol[i]);
        }
    }

    // Compute the output values for the systolic array
    void compute() {
        // Iterate over the rows of processing elements
        for (int i = 0; i < ROWS; i++) {
            // Iterate over the columns of processing elements
            for (int j = 0; j < COLS2; j++) {
                // Compute the output value of the current processing element
                m_peGrid[i][j].m_value += m_peGrid[i][j].l_value * m_peGrid[i][j].top_value;
            }
        }
    }

    void shift() {
        // Iterate over the rows of processing elements
        for (int i = ROWS - 1; i >= 0; i--) {
            // Iterate over the columns of processing elements
            for (int j = COLS2 - 1; j >= 0; j--) {

                if (i < ROWS - 1) {
                    // Forward the input to the next row of processing elements
                    m_peGrid[i + 1][j].top_value = m_peGrid[i][j].top_value;
                }

                if (j < COLS2 - 1) {
                    // Forward the input to the next column of processing elements
                    m_peGrid[i][j + 1].l_value = m_peGrid[i][j].l_value;
                }
            }
        }
    }

    // Print the output values of the systolic array
    void printOutputs() {
        for (int i = 0; i < ROWS; i++) {
            for (int j = 0; j < COLS2; j++) {
                cout << m_peGrid[i][j].m_value << " ";
            }
            cout << endl;
        }
    }

private:
    vector<vector<PE>> m_peGrid;  // grid of processing elements
};

int run_sysarr_test() {
    // Create the systolic array
    SystolicArray sa;

    // Create an array of zeroes for row and column.
    vector<int> zeroVector;

    int maxDim = ROWS >= COLS ? ROWS : COLS;
    maxDim = maxDim >= COLS2 ? maxDim : COLS2;
    int numCycles = (2 * (maxDim - 1) + maxDim);

    cout << "Number of cycles is: " << numCycles << endl;

    // Define the two matrices. 
    vector<vector<int>> matA;
    vector<vector<int>> matB;
    int counter = 1;
    // Initialize them.
    for (int i = 0; i < ROWS; i++) {
        matA.push_back(vector<int>());
        // matB.push_back(vector<int>());
        for (int j = 0; j < COLS; j++) {
            matA[i].push_back(counter);
            // matB[i].push_back(counter);
            counter += 1;
        }
    }
    // counter = 1;
    // Initialize them.
    for (int i = 0; i < ROWS2; i++) {
        // matA.push_back(vector<int>());
        matB.push_back(vector<int>());
        for (int j = 0; j < COLS2; j++) {
            // matA[i].push_back(j + i);
            matB[i].push_back(counter);
            counter += 1;
        }
    }

    cout << "Original Matrix A: " << endl;
    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
            cout << matA[i][j] << " ";
        }
        cout << endl;
    }

    cout << "Original Matrix B: " << endl;
    for (int i = 0; i < ROWS2; i++) {
        for (int j = 0; j < COLS2; j++) {
            cout << matB[i][j] << " ";
        }
        cout << endl;
    }

    // Create the input matrices
    vector<vector<int>> inMatA;
    vector<vector<int>> inMatB;
    // vector<vector<int>> inMatBTemp;

    int lenMat = 2 * maxDim - 1;

    // cout << "max dim: " << maxDim << endl;
    for (int i = 0; i < maxDim; i++) {
        zeroVector.push_back(0);
    }

    for (int j = 0; j < lenMat; j++) {
        inMatA.push_back(vector<int>());
        inMatB.push_back(vector<int>());
        // inMatBTemp.push_back(vector<int>());
        for (int i = 0; i < maxDim; i++) {
            inMatA[j].push_back(0);
            inMatB[j].push_back(0);
            // inMatBTemp[j].push_back(0);
        }
    }


    for (int j = 0; j < ROWS; j++) {
        for (int i = 0; i < COLS; i++) {
            inMatA[i + j][j] = matA[j][i];
        }
    }

    // cout << "HERE" << endl;

    cout << "Modified Matrix A: " << endl;
    for (int i = 0; i < lenMat; i++) {
        for (int j = 0; j < maxDim; j++) {
            cout << inMatA[i][j] << " ";
        }
        cout << endl;
    }


    for (int j = 0; j < COLS2; j++) {
        for (int i = 0; i < ROWS2; i++) {
            inMatB[i + j][j] = matB[i][j];
        }
    }

    cout << "Modified Matrix B: " << endl;
    for (int i = 0; i < lenMat; i++) {
        for (int j = 0; j < maxDim; j++) {
            cout << inMatB[i][j] << " ";
        }
        cout << endl;
    }
    // cout << "HERE2" << endl;


    for (int cycle_count = 0; cycle_count < numCycles; cycle_count++) {
        // cout << cycle_count << endl;
        // Send the data to row and col of the sys array.
        if (cycle_count < lenMat) {
            sa.setInputs(inMatB[cycle_count], inMatA[cycle_count]);
        }
        else {
            sa.setInputs(zeroVector, zeroVector);
        }

        // Compute
        sa.compute();
        // Shift
        sa.shift();
    }
    // Get the output

    // Print the output values of the systolic array
    cout << "The output from matrix multiplication is: " << endl;
    sa.printOutputs();

    return 0;

}

// int main() {
//     run_test();
//     return 0;
// }
