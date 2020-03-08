
DATA="data/guitar-std.dzn data/yardbird-suite.dzn"

for goal in satisfy fret-distance finger-distance; do
    for n in $(seq 5); do
        echo "$goal -O$n"
        minizinc -O$n --output-time src/tablazinc-$goal.mzn $DATA
    done
done
