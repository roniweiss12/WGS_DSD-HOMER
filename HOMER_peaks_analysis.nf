#!/usr/bin/env nextflow

// Define input parameters
params.inputBed = ""
params.homerResults = ""
params.homerWork = ""
params.curProcessedOutputDir = ""


// Define the Nextflow process for running runInitialHomer.sh
process runInitialHomer {
    
    publishDir params.curProcessedOutputDir, mode: 'copy'

    input:
    file params.inputBed
    val params.homerResults
    val params.homerWork

    output:
    path params.homerResults

    script:
    """
    runInitialHomer.sh $params.inputBed $params.homerResults $params.homerWork
    """

}

// Define the Nextflow process for running cat_homer_results.sh
process catHomerResults {

    publishDir params.curProcessedOutputDir, mode: 'copy'

    input:
    val params.homerResults

    output:
    file '$params.homerResults/all_motifs.txt'

    script:
    """
    catHomerResults.sh $params.homerResults
    """
}

// Define the Nextflow process for running runHomerInPeaks.sh
process runHomerInPeaks {
    
    publishDir params.curProcessedOutputDir, mode: 'copy'

    input:
    file params.inputBed
    val params.homerResults
    val params.homerWork

    output:
    file '$params.homerResults/peaks_motif.tsv'

    script:
    """
    runHomerInPeaks.sh $params.inputBed $params.homerResults $params.homerWork
    """
}

// Define the workflow
workflow {
    runInitialHomer(params.inputBed, params.homerResults, params.homerWork)
    catHomerResults(params.homerResults)
    runHomerInPeaks(params.inputBed, params.homerResults, params.homerWork)
}