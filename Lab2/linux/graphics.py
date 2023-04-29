import matplotlib.pyplot as plt
import csv

plt.title("Умножение матриц")
plt.xlabel("Размер квадратной матрицы")
plt.ylabel("Время умножения матриц, ms")

if __name__ == "__main__":
    x_values = []
    y_values = []
    
    with open('output.csv', 'r') as f:
        reader = csv.reader(f, delimiter=' ')
        for row in reader:
            if (row[0] and row[1]):
                x_values.append(float(row[0]))
                y_values.append(float(row[1]))
            else:
                print('Error in file reading: empty params')
        f.close()

    plt.plot(x_values, y_values)
    plt.show()