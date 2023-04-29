#!/bin/bash
# определяем массив чисел
sizes=(1000 2000 3000 4000 5000 6000 7000 8000 9000 10000)

rm output.csv

# перебираем все элементы массива
for size in ${sizes[@]}
do
    program_output=$(./optimized ${size} -t)
    # используем cut для извлечения числа без ms
   
    time_val=$(echo "${program_output}" | cut -d' ' -f1)

    # записываем полученное значение в CSV файл
    echo "${size} ${time_val}" >> output.csv
done

python3 graphics.py