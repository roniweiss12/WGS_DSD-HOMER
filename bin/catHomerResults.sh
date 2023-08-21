#!/bin/bash
#this script takes a folder with HOMER results and concatenates
# known and novel motifs into all_motifs.txt.
HOMER_DIR="$1"

# Check if the knownResults directory exists
if [ ! -d "$HOMER_DIR/knownResults" ]; then
    echo "Directory 'knownResults' not found."
    exit 1
fi

# Concatenate .motif files from knownResults/ directory
cat $HOMER_DIR/knownResults/*.motif > $HOMER_DIR/all_motifs.txt

# Concatenate homerMotifs.all.motifs
cat $HOMER_DIR/homerMotifs.all.motifs >> $HOMER_DIR/all_motifs.txt

echo "Concatenation complete. Result saved in $HOMER_DIR/all_motifs.txt."
