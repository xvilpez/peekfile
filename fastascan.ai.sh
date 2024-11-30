#!/bin/bash

#Defining arguments: X is the folder to search for files and N the number of lines
X=$1
[ -z $X ] && X=.
	
N=$2
[ -z $N ] && N=0

#Ensuring that the directory exists
if [[ -d $X ]]; then 

	fastas=$(find "$X" -type f -name "*.fa" -or -name "*.fasta")
	echo "#####START OF THE REPORT#####"
	echo
	
	#Ensuring that there are fasta files in the variable fastas
	if [[ -n $fastas ]]; then
		
		echo '####NUMBER OF FILES####'
		echo
		num_fastas=$(echo "$fastas" | wc -l)
		echo "$num_fastas FASTA files found in $X and its subfolders."
		echo
		
		echo '####NUMBER OF UNIQUE FASTA IDs####'
		echo
		uniq_IDs=$(grep "^>" $fastas | awk '{print $1}' | sort | uniq | wc -l)
		echo "$uniq_IDs unique FASTA IDs found."
		echo
			
		echo '#####Starting report on all fasta files found#####'
		echo
		for file in $fastas; do
			#Ensure that the file has permissions and content
			if [[ -r $file ]]; then
				if [[ -s $file ]]; then
				
					#Label the header differentiating between protein and nucleotide fasta files
					grep -v "^>" $file | ( grep -q [RDEQHILKMFPSWYV]  && echo "###FASTA PROTEIN FILE=$file###") || echo "###FASTA NUCLEOTIDE FILE=$file###"
					echo
					
					#Classify between symlinks or regular files
					[ -h $file ] && echo $file is a symlink. && echo
						
					#Counting the amount of sequences and the total aminoacids/nucleotides of that file
					echo Total sequences: $(grep -c "^>" $file)

					echo Total sequence length: $(grep -v "^>" $file | awk '{gsub(/[- \n]/, ""); total += length} END {print total}'
).
					echo
					
					if [[ $N -gt 0 ]]; then #Skips step if the number of lines is set to 0 (default parameter).
					echo "#Showing content of $file"
					echo

					([ $(cat $file | wc -l) -le $((2*$N)) ] && cat $file) || head -n $N $file; echo ...; tail -n $N $file
					echo
					fi
		
		###WARNINGS/ERRORS section		
				else echo "###FASTA FILE=$file###"; echo; echo WARNING:$file IS AN EMPTY FASTA FILE!!!
					echo
				fi
				
			else echo "###FASTA FILE=$file###"; echo; echo WARNING: $file HAS NO READ PERMISSIONS!!!
				echo
			fi
		done

	else echo There are no fasta files in $X and subfolders.
	fi
	
	echo "#####END OF THE REPORT#####"
	
else echo ERROR: THE FOLDER DOES NOT EXIST!!!
fi


