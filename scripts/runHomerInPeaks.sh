#!/bin/bash

module load hurcs homer
# Set the path to the HOMER program
OUTPUT_DIR="$1" 

# Check if the HOMER output file exists
if [ ! -f "$OUTPUT_DIR/all_motifs.txt" ]; then

  echo "allMotifs.txt file not found."
  exit 1
fi
# Parse the HOMER output to extract motif occurrences and corresponding peaks
 
findMotifsGenome.pl "$PEAK_FILE" hg38 "$OUTPUT_DIR" -size 200 -mask -preparsedDir "$OUTPUT_DIR" -find "$OUTPUT_DIR/all_motifs.txt" > $OUTPUT_DIR/peaks_motif.tsv
echo "Motif discovery and peak analysis completed successfully."
