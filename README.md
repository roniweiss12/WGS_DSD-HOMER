# Homer Pipeline
This repository contains a Nextflow pipeline for performing motif analysis in specific regions of the genome using Homer while subtracting a background.

## Pipeline Overview
The provided Nextflow pipeline automates the following steps:

1. `runInitialHomer` with an input background BED file.
2. `cat_homer_results` with the HOMER results files produced by the previous step.
3. `runHomerInPeaks` running Homer on the subject bed file, while subtracting the motifs found in the background BED file.
4. `find_relevant_motifs.py` find relevant motifs of TF, provided in keyTF.csv, in the result motifs.

## Parameters

`params.backgroundBed`

`params.subjectBed`

`params.homerResults` - results directory

`params.bin` - path to directory containing scripts and additional files such as keyTF.csv (a list of TF of interest)

## Running the Pipeline

Run the pipeline using Nextflow:

`nextflow WGS_DSD-HOMER/HOMER_peaks_analysis.nf --backgroundBed 'path/to/file.bed' --subjectBed 'path/to/file.bed' --homerResults 'results/path' --bin /path/to/WGS_DSD-HOMER/bin/`
