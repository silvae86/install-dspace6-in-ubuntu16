#!/usr/bin/env bash

#example
#./split_and_import_csv.sh
#  --csv /home/arus/registos_15_10_2017.csv
#  --eperson utopia@letras.up.pt
#  --collection "123456789/938"
#  --chunksize 100
#  --dspace_dir /dspace

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

[[ "$@" == *--csv* ]] || usage
[[ "$@" == *--collection* ]] || usage
[[ "$@" == *--chunksize* ]] || usage
[[ "$@" == *--eperson* ]] || usage
[[ "$@" == *--dspace_dir* ]] || usage

#get arguments
while test "$#" != "0";
do
  case "$1" in
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

if [[ $CSV_FILE == "" ]] || [[ $COLLECTION_ID == "" ]] || [[ $CHUNK_SIZE == "" ]]
then
  usage
fi

echo "Splitting $CSV_FILE into files with $CHUNK_SIZE lines at $CHUNKS_FOLDER"

#save working dir
INITIAL_DIR=$(pwd)

#recreate folder to put chunks in
rm -rf $CHUNKS_FOLDER
mkdir -p $CHUNKS_FOLDER

#save header and remove it into a temporary file without header
HEADER=$(head -1 "$CSV_FILE")
echo "tail -n +2 $CSV_FILE" > csv_without_header.csv.tmp

#split the file without header
split -l "$CHUNK_SIZE" csv_without_header.csv.tmp "$CHUNKS_FOLDER/$CHUNKS_FILE_NAME"
rm -rf csv_without_header.csv.tmp

cd $CHUNKS_FOLDER || echo "Unable to cd to $CHUNKS_FOLDER"

i=0
for f in *; do
    #add header and rename chunks to have .csv extension at the end
    CONTENTS=$(printf "$HEADER\n" && cat $f)
    echo $CONTENTS > "$f.csv"
    rm "$f"
    #import file
    $DSPACE_DIR/dspace/bin/dspace import -s "$f.csv" -i csv -m ./map_import_$i -b -e $EPERSON -c "$COLLECTION_ID"
	$((i++))
done

cat ./map_import* > ./map_import

#rebuild indexes
"$DSPACE_DIR/dspace/bin/dspace" index-discovery

#clean temporary files
rm -rf $CHUNKS_FOLDER

cd $INITIAL_DIR || echo "unable to return to initial dir" && exit 1
