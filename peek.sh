input_file=$1
n_lines=$2

if [[ -z $n_lines ]]; then 
	n_lines=3
fi

if [[ $(cat $input_file | wc -l) -le $(( 2*$n_lines )) ]]; then 	
	
	cat $input_file

else 
	echo WARNING:$input_file has more than $(( 2*$n_lines )) lines!
	head -n $n_lines $input_file
	echo ...
	tail -n $n_lines $input_file
fi
