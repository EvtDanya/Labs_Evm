#!/bin/bash

sizes=(100 200 300 400 500)
modes=("--opt0" "--opt1" "--opt2=32")
block_sizes=(2 4 8 16 32 64 128)
filename=""

echo "[*] starting tests..."

if [ "$1" == "all" ]; then
    echo "[*] you chose all tests"
    
    echo "[*] deleting old results..."
    filenames=("Opt0" "Opt1" "Opt2")
    for file in ${filenames[@]}; do
        if [ -f output${filename}.csv ]; then
            rm output${filename}.csv
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
        elif [[ "${mode}" == --opt2=* ]]; then
            echo "[*] starting tests with dgemm function with blocks..."
            filename="Opt2"
        fi
        
        for size in ${sizes[@]};
        do  
            program_output=$(./optimized ${size} ${mode} -t)         
            time_val=$(echo "${program_output}" | cut -d' ' -f1)

            echo "${size} ${time_val}" >> output${filename}.csv
        done
        echo "[*] done, writing results to output${filename}.csv"
    done

elif [ "$1" == "blocks" ]; then
    echo "[*] you chose tests with blocks"

    echo "[*] deleting old results..."
    for block_size in ${block_sizes[@]};
    do
        if [ -f "outputBlock${block_size}.csv" ]; then
            rm outputBlock${block_size}.csv
        fi
    done
    echo "[*] deleted"

    for block_size in ${block_sizes[@]};
    do 
        for size in ${sizes[@]};
        do  
            program_output=$(./optimized ${size} --opt2=${block_size} -t)         
            time_val=$(echo "${program_output}" | cut -d' ' -f1)

            echo "${size} ${time_val}" >> outputBlock${block_size}.csv
        done        
    done
else
    echo "Incorrect argument! Use 'all' or 'blocks' instead"
    exit 1
fi


echo "[*] finished!"
echo "[*] starting python module with graphics drawing..."
python3 graphics.py "$1"