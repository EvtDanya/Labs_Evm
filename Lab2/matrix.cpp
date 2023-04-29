#include <iostream>
#include <cstdlib>
#include <ctime>
#include <iomanip>
#include <string>

using namespace std;

double** createMatrix(int size) {
    double** matrix;  
    matrix = new double*[size];
    for (int i = 0; i < size; i++) 
        matrix[i] = new double[size];

    return matrix;
}

void initMatrix(double **matrix, int size) {
    for (int i = 0; i < size; i++) 
        for (int j = 0; j < size; j++) 
            matrix[i][j] = (double) rand() / RAND_MAX;
}

void printMatrix(double **matrix, int size) {
for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            std::cout << std::setw(10) << matrix[i][j] << " ";
        }
        std::cout << std::endl;
    }
}

void deleteMatrix(double **matrix, int size) {
    for (int i = 0; i < size; i++) 
        delete[] matrix[i];

    delete[] matrix;
}

double **dgemm_blas(double **a, double **b, int n) {
    double **c = createMatrix(n);

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            for (int k = 0; k < n; k++) {
                c[i][j] = a[i][k] * b[k][j];
            }
        }
    }

    return c;
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        cout << "Usage: " << argv[0] << "<output: y/n> <matrix size>" << endl;
        return 0;
    }
    string output = argv[1];
    if (output != "y" && output != "n") {
        cout << "You must specify y/n with the first argument, not " << output << endl;
        return 0;
    }

    srand(time(NULL));

    string needToPrint=argv[1];
    int n = atoi(argv[2]);

    double **a = createMatrix(n);
    double **b = createMatrix(n);
    
    initMatrix(a, n);
    initMatrix(b, n);

    double **c = dgemm_blas(a, b, n);

    if (output == "y") {
        std::cout << "Matrix A:" << std::endl;
        printMatrix(a,n);

        std::cout << "Matrix B:" << std::endl;
        printMatrix(b,n);

        std::cout << "Matrix C = A * B:" << std::endl;
        printMatrix(c,n);
    }
    
    deleteMatrix(a,n);
    deleteMatrix(b,n);
    deleteMatrix(c,n);

    return 0;
} 