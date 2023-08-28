# Homer Pipeline
This repository contains a Nextflow pipeline for performing motif analysis in specific regions of the genome using Homer.

## Pipeline Overview
The provided Nextflow pipeline automates the following steps:

1. `runInitialHomer` with an input BED file.
2. `cat_homer_results` with the HOMER results files produced by the previous step.
3. `runHomerInPeaks` re-runnig Homer within the specific regions provided in the input BED file using the motifs produced by the first steps.

## Parameters

`params.inputBed`: The input regions in a bed file.

`params.homerResults`: Folder for the results.

## Running the Pipeline

Run the pipeline using Nextflow:

`nextflow WGS_DSD-HOMER/HOMER_peaks_analysis.nf --inputBed 'path/to/file.bed' --homerResults 'results/path'`
