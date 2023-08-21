#!/bin/bash
#this script takes a folder with HOMER results and concatenates
# known and novel motifs into all_motifs.txt.
HOMER_RSULTS="$1"
OUTPUT_DIR="$2"

# Check if the knownResults directory exists
if [ ! -d "$HOMER_RSULTS/knownResults" ]; then
    echo "Directory 'knownResults' not found."
    exit 1
fi

# Concatenate .motif files from knownResults/ directory
cat $HOMER_RSULTS/knownResults/*.motif > $OUTPUT_DIR/all_motifs.txt

# Concatenate homerMotifs.all.motifs
cat $HOMER_RSULTS/homerMotifs.all.motifs >> $OUTPUT_DIR/all_motifs.txt

echo "Concatenation complete. Result saved in $OUTPUT_DIR/all_motifs.txt."
