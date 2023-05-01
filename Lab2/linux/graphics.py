import matplotlib.pyplot as plt
import csv
import sys

plt.title("Умножение матриц")
plt.xlabel("Размер квадратной матрицы")
plt.ylabel("Время умножения матриц, ms")

if __name__ == "__main__":
    descriptions = {}
    
    if sys.argv[1] != "all" and sys.argv[1] != "blocks":
        print("[ERROR!] Unknown argument: %s\nAvailable args: 'all', 'blocks'" % sys.argv[1])
        sys.exit()
        
    else:
        if sys.argv[1] == "all":
            descriptions = {"outputOpt0.csv": "dgemm_blas", "outputOpt1.csv": "dgemm_opt1", "outputOpt2.csv": "dgemm_opt2"}
        else:
            nums = [2,4,8,16,32,64,128]
            for num in nums:
                descriptions.update({f"outputBlock{num}.csv": f"block_size = {num}"})
            
    for filename in descriptions.keys():
        x_values = []
        y_values = []

        with open(filename, 'r') as f:
            reader = csv.reader(f, delimiter=' ')
            for row in reader:
                if (row[0] and row[1]):
                    x_values.append(float(row[0]))
                    y_values.append(float(row[1]))
                else:
                    print('Error in file reading: empty params')
            f.close()

        plt.plot(x_values, y_values, label=descriptions[filename])    
        
    plt.show()