#!/usr/bin/env nextflow

// Define input parameters
params.inputBed = ''
params.homerResults = ''
params.curProcessedOutputDir = ''

// Define the Nextflow process for running runInitialHomer.sh
process runInitialHomer {
    
    publishDir params.curProcessedOutputDir, mode: 'copy'

    input:
    Tuple file(inputBed), path(homerResults)

    script:
    """
    runInitialHomer.sh $inputBed $homerResults
    """

}

// Define the Nextflow process for running cat_homer_results.sh
process catHomerResults {
    input:
    file homerResults

    output:
    path homerResults

    script:
    """
    catHomerResults.sh ${homerResults}
    """
}

// Define the Nextflow process for running runHomerInPeaks.sh
process runHomerInPeaks {
    input:
    file inputBed
    file homerResults

    output:
    path homerResults

    script:
    """
    runHomerInPeaks.sh ${inputBed} ${homerResults}
    """
}

// Define the workflow
workflow {
    // Run the steps sequentially
    runInitialHomer(params.inputBed, params.homerResults, params.curProcessedOutputDir)
    catHomerResults(runInitialHomer.out)
    runHomerInPeaks(params.inputBed, catHomerResults.out)
}
