#!/bin/bash

# Check if HOMER is installed and accessible
#if ! command -v "$HOMER_PATH/findMotifsGenome.pl" &>/dev/null; then
#  echo "HOMER not found or the path is incorrect. Please set the HOMER_PATH variable correctly."
#  exit 1
#fi

# Input BED file (hg38 format)
INPUT_BED="$1"  # Replace with the path to your hg38 BED file
OUTPUT_DIR="HOMER_res"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Step 1: Run HOMER to find motifs in the BED file

echo  "$INPUT_BED" hg38 "$OUTPUT_DIR" -size 200 -mask -preparsedDir "$OUTPUT_DIR" 

findMotifsGenome.pl "$INPUT_BED" hg38 "$OUTPUT_DIR" -size 200 -mask -preparsedDir "$OUTPUT_DIR"  -preparse
