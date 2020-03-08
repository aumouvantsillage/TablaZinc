
DATA="data/guitar-std.dzn data/yardbird-suite.dzn"

for goal in satisfy fret-distance finger-distance; do
    for par in $(seq 2); do
        for opt in $(seq 5); do
            echo "$goal -p $par -O$opt"
            minizinc -p $par -O$opt --output-time src/tablazinc-$goal.mzn $DATA
        done
    done
done
