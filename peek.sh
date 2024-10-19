input_file=$1
n_lines=$2

head -n $n_lines $input_file
echo ...
tail -n $n_lines $input_file

