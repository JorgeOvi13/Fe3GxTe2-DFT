#!/bin/bash

echo -e "Ratio\tTotalEnergy(eV)" > energy_vs_ratio.dat

for dir in ratio_*; do
    out_file="$dir/output.out"
    ratio=$(echo "$dir" | sed 's/ratio_//')  # Extract number from directory name

    if grep -q "siesta:         Total =" "$out_file"; then
        energy=$(grep "siesta:         Total =" "$out_file" | tail -1 | awk '{print $4}')
        echo -e "$ratio\t$energy" >> energy_vs_ratio.dat
    else
        echo "No total energy found in $dir — likely not converged."
    fi
done