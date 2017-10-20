#!/usr/bin/env bash

set -o history -o histexpand

sudo apt-get install -y -q gnumeric

#example
#./split_and_import_csv.sh
#  --csv /home/arus/registos_15_10_2017.csv
#  --eperson utopia@letras.up.pt
#  --collection "123456789/938"
#  --chunksize 100
#  --dspace_dir /dspace

#save working dir
INITIAL_DIR=$(pwd)


#set parameters
programname=$0
CHUNKS_FOLDER="split_files"
CHUNKS_FILE_NAME="chunk"

#validate usage
function usage {
    echo "usage: $programname --csv test.csv --collection 12345678/12345 --chunksize 200 --eperson user@your_dspace.com --dspace_dir"
    echo "  --csv      <path to the csv file to import>, example csv_file_with_entries.csv"
    echo "  --collection    <collection id> , example 123456/12345"
    echo "  --chunksize <size of each chunk>, example 200"
    echo "  --eperson EPerson responsible for the import, example user@your_dspace.com"
    echo "  --dspace_dir DSpace installation directory, example /dspace (must contain /dspace/bin directory)"
    exit 1
}

[[ "$@" == *--collection* ]] || usage
[[ "$@" == *--chunksize* ]] || usage
[[ "$@" == *--eperson* ]] || usage
[[ "$@" == *--dspace_dir* ]] || usage

#get arguments
while test "$#" != "0";
do
  case "$1" in
          --xlsx*)
              XLSX_FILE="$2"
              ;;
          --csv*)
                  CSV_FILE="$2"
                  ;;
          --collection*)
                  COLLECTION_ID="$2"
                  ;;
          --chunksize*)
                  CHUNK_SIZE="$2"
                  ;;
          --eperson*)
                  EPERSON="$2"
                  ;;
          --dspace_dir*)
                  DSPACE_DIR="$2"
                  ;;
          --) shift; break;;
  esac
  shift
done

if [[ ! -f "$DSPACE_DIR/dspace/bin/dspace" ]]
then
  printf "Invalid dspace location, because the file $DSPACE_DIR/dspace/bin/dspace does not exist or is not a file.\n"
  exit 1
fi

if [[ $COLLECTION_ID == "" ]] || [[ $CHUNK_SIZE == "" ]]
then
  usage
fi

if [[ "$CSV_FILE" == "" ]] && [[ "$XLSX_FILE" == "" ]]
then
  usage
else
        if [[ "$CSV_FILE" != "" ]]
        then
                INPUT_FILE=$CSV_FILE
        elif [[ "$XLSX_FILE" != "" ]]
        then
                echo "Converting XLSX file to CSV..."
                rm "$XLSX_FILE.csv"
                ssconvert "$XLSX_FILE" "$XLSX_FILE.csv" >> /dev/null
                INPUT_FILE="$XLSX_FILE.csv"
        fi
fi

file_size_kb=`du -k "$INPUT_FILE" | cut -f1`
number_of_lines=`wc -l $INPUT_FILE`

echo "Splitting $INPUT_FILE ($file_size_kb KB and $number_of_lines lines) into files with $CHUNK_SIZE lines at $CHUNKS_FOLDER"
chmod +x ./split_csv.sh
./split_csv.sh $CHUNK_SIZE $INPUT_FILE $CHUNKS_FOLDER

exit 1

rm -rf ./maps
mkdir -p ./maps

i=0
echo "###############################################"
echo "starting to process files at "$CHUNKS_FOLDER""
echo "###############################################"
ls -la ./$CHUNKS_FOLDER

for f in "$CHUNKS_FOLDER"
do
    echo "processing $f"
    #add header and rename chunks to have .csv extension at the end
    CONTENTS=$(printf "$HEADER\n" && cat $f)
    echo $CONTENTS > "$f.csv"
    #import file
    $DSPACE_DIR/dspace/bin/dspace import -s "$f.csv" -i csv -m ./maps/map_import_$i -b -e $EPERSON -c "$COLLECTION_ID" || echo "failed to import $f.csv" && exit 1
    i=$(($i+1))
done

#clean temporary files
rm -rf $CHUNKS_FOLDER

#create consolidated mapfile
rm ./map_import
cat ./maps/map_import* > ./map_import

#rebuild indexes
./dspace index-discovery

cd "$INITIAL_DIR" || echo "unable to return to initial dir" && exit 1
