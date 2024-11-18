#Defining arguments: X is the folder to search for files and N the number of lines
X=$1
[ -z $X ] && X=.
	
N=$2
[ -z $N ] && N=0

fastas=$(find $X -type f -name "*.fa" -or -name "*.fasta")

#Ensuring that there are fasta files in the variable fastas
if [[ -n $fastas ]]; then

#Reporting number of files
echo There are $(find $X -type f -name "*.fa" -or -name "*.fasta" | wc -l) fasta files in $X folder and subfolders.

#Reporting number of unique fasta IDs
echo There are $(grep ">" $fastas | awk '{print $1}' | sort | uniq | wc -l) unique fasta IDs.


for i in $fastas; do
	if [[ -s $i ]]; then
		echo file==================$i.
		([ -h $i ] && echo $i is a symlink.) || echo $i is not a symlink.
		echo There are $(grep -c ">" $i) sequences inside $i. 
		echo The total sequence length of $i is $(grep -v ">" $i | sed 's/[- \n]//g' | awk '{total=total + length} END {print total}').
		grep -v ">" $i | sed 's/[- \n]//g' | ( grep -q [RDEQHILKMFPSWYV]  && echo $i is a protein fasta file) || echo $i is a nucleotide fasta file.
	
		else echo $i is an empty fasta file.
	fi
done

else echo There are no fasta files in $X folder and subfolders.

fi



