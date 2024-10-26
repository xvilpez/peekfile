input_file=$1

echo $input_file

if [[ $(cat $input_file | wc -l) -eq 0 ]]; then
	echo The file has 0 lines.

elif [[ $(cat $input_file | wc -l) -eq 1 ]]; then
	echo The file has 1 line.

else 
	echo The file has more than 1 line.

fi
