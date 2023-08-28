#!/usr/bin/env nextflow

// Define input parameters
params.inputBed = ""
params.homerResults = ""
params.curProcessedOutputDir = ""

process runInitialHomer {

   input:

      file regionsFile
      val homerDir
   
   output:
      path "${homerDir}/knownResults", emit: knownMotif
      path "${homerDir}/homerMotifs.all.motifs", emit: novelMotif
      path "${homerDir}"
   
   script:
      known_motif = "${homerDir}/knownResults"
      """
      mkdir ${homerDir}
      findMotifsGenome.pl ${regionsFile} hg38 ${homerDir} -preparsedDir ${homerDir}
      """
}

process catHomerResults {

    input:
    path knownResults
    path homerMotifs
    path homerDir

    output:
    file "${homerDir}/all_motifs.txt"

    script:
    """
    cat ${knownResults}/*.motif > ${homerDir}/all_motifs.txt
    cat ${homerMotifs} >> ${homerDir}/all_motifs.txt
    """
}


process runHomerInPeaks {
    
    publishDir params.homerResults, mode: 'copy'

    input:
    file regionsFile
    val homerDir
    file allMotifs

    output:
    file "peaks_motif.tsv"

    script:
    """
    findMotifsGenome.pl ${regionsFile} hg38 ${homerDir} -size 200 -mask -preparsedDir ${homerDir} -find ${allMotifs} > peaks_motif.tsv
    echo "your results are now at: ${homerDir}/peaks_motif.tsv"
    """
}

workflow {
    def regions = Channel.fromPath(params.inputBed)
    initHomer = runInitialHomer(regions, params.homerResults)
    concatHomer = catHomerResults(initHomer)
    runHomerInPeaks(regions, params.homerResults, concatHomer)
}