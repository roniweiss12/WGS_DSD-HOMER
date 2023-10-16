#!/usr/bin/env nextflow

// Define input parameters
params.backgroundBed = ""
params.subjectBed = ""
params.homerResults = ""
params.bin = ""
params.curProcessedOutputDir = params.homerResults

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
    file subjectRegionsFile
    val homerDir
    file allMotifs

    output:
    file "peaks_motif.tsv"

    script:
    """
    findMotifsGenome.pl ${subjectRegionsFile} hg38 ${homerDir} -size 200 -mask -preparsedDir ${homerDir} -find ${allMotifs} > peaks_motif.tsv
    echo "your results are now at: ${homerDir}/peaks_motif.tsv"
    """
}

process findTFmotoifs {
    
    publishDir params.homerResults, mode: 'copy'

    input:
    //file "keyTF.csv"
    file "peaks_motif.tsv"

    output:
    file "keyTF_motifs_in_peaks.csv"

    script:
    """
    for file in ${params.bin}*; do
        ln -s "\$file" .
    done
    python find_relevant_motifs.py keyTF.csv peaks_motif.tsv
    """
}

workflow {
    def backgroundRegions = Channel.fromPath(params.backgroundBed)
    initHomer = runInitialHomer(backgroundRegions, params.homerResults)
    concatHomer = catHomerResults(initHomer)
    def subjectRegions = Channel.fromPath(params.subjectBed)
    peaksMotifFile = runHomerInPeaks(subjectRegions, params.homerResults, concatHomer)
    findTFmotoifs(peaksMotifFile)
}
