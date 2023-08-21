# Homer Pipeline
This repository contains a Nextflow pipeline for performing motif analysis in specific regions of the genome using the Homer tool.

## Pipeline Overview
The provided Nextflow pipeline automates the following steps:

1. Running `runInitialHomer.sh` with an input BED file.
2. Running `cat_homer_results.sh` with the HOMER results file produced by the previous step.
3. Running `runHomerInPeaks.sh` with the input BED file and the HOMER results produced by the second step.

## Parameters
The pipeline script makes use of various parameters to control its behavior. Some important parameters include:

params.regionFile: The input region file for motif analysis.
params.homerFolder: Folder for Homer results.

## Running the Pipeline

Run the pipeline using Nextflow:

`nextflow homer_workflow.nf --inputBed /path/to/your/input.bed --homerResults /path/to/your/homer_results.txt`
