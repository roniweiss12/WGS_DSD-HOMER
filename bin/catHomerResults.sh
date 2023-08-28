#!/bin/bash
#this script takes a folder with HOMER results and concatenates
# known and novel motifs into all_motifs.txt.
KNOWN_DIR="$1"
NOVEL_FILE="$2"
HOMER_DIR="$3"

# Check if the knownResults directory exists
# if [ ! -e "$HOMER_DIR/knownResults" ]; then
#     echo "Directory 'knownResults' not found."
#     exit 1
# fi
touch $HOMER_DIR/all_motifs.txt
# Concatenate .motif files from knownResults/ directory
cat $KNOWN_DIR/*.motif > $HOMER_DIR/all_motifs.txt

# Concatenate homerMotifs.all.motifs
cat $NOVEL_FILE >> $HOMER_DIR/all_motifs.txt

echo "Concatenation complete. Result saved in $HOMER_DIR/all_motifs.txt."
