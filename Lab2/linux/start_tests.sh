#!/bin/bash

sizes=(100 200 300 400 500 600 700 800 900 1000)
modes=("--opt0" "--opt1" "--opt2=32" "vect")
block_sizes=(2 4 8 16 32 64 128)
filename=""

echo "[*] starting tests..."

if [ "$1" == "all" ]; then
    echo "[*] you have chosen all tests"
    
    echo "[*] deleting old results..."
    filenames=("Opt0" "Opt1" "Opt2")
    for file in ${filenames[@]}; 
    do
        if [ -f output${file}.csv ]; then
            echo "da"
            rm output${file}.csv
        fi
    done
    echo "[*] deleted"

    for mode in ${modes[@]};
    do
        if [ "${mode}" == "--opt0" ]; then
            echo "[*] starting tests with default dgemm function..."
            filename="Opt0"
        elif [ "${mode}" == "--opt1" ]; then
            echo "[*] starting tests with transpose dgemm function..."
            filename="Opt1"
        elif [ "${mode}" == --opt2=* ]; then
            echo "[*] starting tests with dgemm function with blocks..."
            filename="Opt2"
        elif [ "${mode}" == "vect" ]; then
            echo "[*] starting tests with dgemm function with vectorization..."
            filename="Opt3"
        fi
        
        for size in ${sizes[@]};
        do  
            program_output=$(./optimized ${size} ${mode} -t)   
            if [ "${mode}" == "vect" ]; then
                program_output=$(./optimized3 ${size} --opt1 -t)   
            fi      
            time_val=$(echo "${program_output}" | cut -d' ' -f1)

            echo "${size} ${time_val}" >> output${filename}.csv
        done
        echo "[*] done, writing results to output${filename}.csv"
    done

elif [ "$1" == "blocks" ]; then
    echo "[*] you have chosen tests with blocks"

    echo "[*] deleting old results..."
    for block_size in ${block_sizes[@]};
    do
        if [ -f outputBlock${block_size}.csv ]; then
            rm outputBlock${block_size}.csv
        fi
    done
    echo "[*] deleted"

    for block_size in ${block_sizes[@]};
    do 
        echo "[*] starting tests with block_size=${block_size}..." 
        for size in ${sizes[@]};
        do  
            program_output=$(./optimized ${size} --opt2=${block_size} -t)         
            time_val=$(echo "${program_output}" | cut -d' ' -f1)

            echo "${size} ${time_val}" >> outputBlock${block_size}.csv
        done 
        echo "[*] done, writing results to outputBlock${block_size}.csv"       
    done
else
    echo "Incorrect argument! Use 'all' or 'blocks' instead"
    exit 1
fi


echo "[*] finished!"
echo "[*] launching the python module with drawing graphs..."
python3 graphics.py "$1"