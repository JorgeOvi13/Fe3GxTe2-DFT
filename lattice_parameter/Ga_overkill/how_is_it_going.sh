#!/bin/bash

echo "===== Tailing output.out files in ratio_* directories ====="

for dir in ratio_*; do
    out_file="$dir/output.out"
    
    if [[ -f "$out_file" ]]; then
        echo -e "\n--- $out_file ---"
        tail -n 10 "$out_file"
    else
        echo -e "\n--- $out_file not found ---"
    fi
done