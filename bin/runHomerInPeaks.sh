#!/bin/bash

PEAK_FILE="$1"
OUTPUT_DIR="$2" 
WORK_DIR="$1"
MOTIFS_FILE="$4"

# Check if the HOMER output file exists
if [ ! -f "$MOTIFS_FILE" ]; then

  echo "allMotifs.txt file not found."
  exit 1
fi
# Parse the HOMER output to extract motif occurrences and corresponding peaks
echo "$MOTIFS_FILE is found" 
findMotifsGenome.pl "$PEAK_FILE" hg38 "$OUTPUT_DIR" -size 200 -mask -preparsedDir "$OUTPUT_DIR" -find $MOTIFS_FILE > $OUTPUT_DIR/peaks_motif.tsv
echo "Motif discovery and peak analysis completed successfully."
