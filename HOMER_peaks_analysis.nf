#!/usr/bin/env nextflow

// Define input parameters
params.inputBed = file("$1")
params.homerResults = file("$2")

// Define the Nextflow process for running runInitialHomer.sh
process runInitialHomer {
    input:
    file inputBed

    script:
    """
    ./scripts/runInitialHomer.sh ${inputBed}
    """
}

// Define the Nextflow process for running cat_homer_results.sh
process catHomerResults {
    input:
    file homerResults

    script:
    """
    ./scripts/catHomerResults.sh ${homerResults}
    """
}

// Define the Nextflow process for running runHomerInPeaks.sh
process runHomerInPeaks {
    input:
    file inputBed
    file homerResults

    script:
    """
    ./scripts/runHomerInPeaks.sh ${inputBed} ${homerResults}
    """
}

// Define the workflow
workflow {
    // Run the steps sequentially
    runInitialHomer(params.inputBed)
    catHomerResults(runInitialHomer.out)
    runHomerInPeaks(params.inputBed, catHomerResults.out)
}
