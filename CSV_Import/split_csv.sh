#!/bin/bash

#USAGE: To split filename.csv into n files containing a maximum of 100 lines each
#	./splitcsv.sh 100 filename.csv

#Obtains input parameters
max_lines=$1
file_name=$2
subdir=$3

#Creates a temporary file with the csv header
head -n 1 ${file_name} > .tmp_header.csv

#Splits the given file into some files
echo "Spliting ${file_name} into ${subdir}, this step may take a while"

split -d -l ${max_lines} ${file_name} .tmp_splitcsv_

rm -rf $subdir
mkdir -p $subdir

#move split files to subdir
for this_file in .tmp_splitcsv_*
do
	echo "Generating... ${this_file:5}"

	#First file already has the header
	if [ ${this_file} == .tmp_splitcsv_00 ];
	then
		mv ${this_file} $subdir/${this_file:5}.csv
	else
        cat .tmp_header.csv ${this_file} > $subdir/${this_file:5}.csv 
	fi
done

#Removes temporary files
echo "Removing temporary files"

rm .tmp_header.csv
rm .tmp_splitcsv_*

echo "Done!"
