#Defining arguments: X is the folder to search for files and N the number of lines
X=$1
[ -z $X ] && X=.
	
N=$2
[ -z $N ] && N=0

#Ensuring that the directory exists
if [[ -d $X ]]; then 

	fastas=$(find $X -type f -name "*.fa" -or -name "*.fasta")
	echo "#####START OF THE REPORT#####"
	echo
	
	#Ensuring that there are fasta files in the variable fastas
	if [[ -n $fastas ]]; then
		
		echo '####NUMBER OF FILES####'
		([ $(find $X -type f -name "*.fa" -or -name "*.fasta" | wc -l) -gt 1 ] && echo There are $(find $X -type f -name "*.fa" -or -name "*.fasta" | wc -l) fasta files in $X folder and subfolders.) || echo There is 1 fasta file in $X folder and subfolders.
		echo
			
		echo '####NUMBER OF UNIQUE FASTA IDS####'
		([ $(grep "^>" $fastas | awk '{print $1}' | sort | uniq | wc -l) -gt 1 ] && echo There are $(grep "^>" $fastas | awk '{print $1}' | sort | uniq | wc -l) unique fasta IDs.) || echo There is only 1 unique fasta ID.
		echo
			
		echo '#####Starting report on all fasta files found#####'
		echo
		for i in $fastas; do
			#Ensure that the file has permissions and content
			if [[ -r $i ]]; then
				if [[ -s $i ]]; then
				
					#Label the header differentiating between protein and nucleotide fasta files
					grep -v "^>" $i | sed 's/[- \n]//g' | ( grep -q [RDEQHILKMFPSWYV]  && echo "###FASTA PROTEIN FILE=$i###") || echo "###FASTA NUCLEOTIDE FILE=$i###"
					echo
					
					#Classify between symlinks or regular files
					[ -h $i ] && echo $i is a symlink. && echo
						
					#Counting the amount of sequences and the total aminoacids/nucleotides of that file
					([ $(grep -c "^>" $i) -gt 1 ] && echo There are $(grep -c "^>" $i) sequences inside $i.) || echo There is 1 sequence inside $i.
					echo The total sequence length of $i is $(grep -v "^>" $i | sed 's/[- \n]//g' | awk '{total=total + length} END {print total}').
					echo
					
					if [[ $N -gt 0 ]]; then #Skips step if the number of lines is set to 0 (default parameter).
					echo "#Showing content of $i"
					echo

					([ $(cat $i | wc -l) -le $((2*$N)) ] && cat $i) || head -n $N $i; echo ...; tail -n $N $i
					echo
					fi
		###WARNINGS/ERRORS section		
				else echo "###FASTA FILE=$i###"; echo; echo WARNING:$i IS AN EMPTY FASTA FILE!!!
					echo
				fi
				
			else echo echo "###FASTA FILE=$i###"; echo; echo WARNING: $i HAS NO READ PERMISSIONS!!!
				echo
			fi
		done

	else echo There are no fasta files in $X and subfolders.
	fi
	
	echo "#####END OF THE REPORT#####"
	
else echo ERROR: THE FOLDER DOES NOT EXIST!!!
fi


