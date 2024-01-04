#!/usr/bin/env nextflow

// Define input parameters
params.backgroundBed = ""
params.subjectBed = ""
params.homerResults = ""
params.bin = ""
params.tfListFile = ""
params.size = "given"

process runInitialHomer {
    
   input:

      file regionsFile
      file backgroundFile
      val homerDir
   
   output:
      path "${homerDir}/knownResults/", emit: knownMotif
      path "${homerDir}/homerMotifs.all.motifs", emit: novelMotif
      path "${homerDir}"
   
   script:
      known_motif = "${homerDir}/knownResults"
      if (backgroundFile.endsWith('.bed')){
        """
        mkdir ${homerDir}
        findMotifsGenome.pl ${regionsFile} hg38 ${homerDir} -preparsedDir ${homerDir} -bg ${backgroundFile}
        """
      } else {
        """
        mkdir ${homerDir}
        findMotifsGenome.pl ${regionsFile} hg38 ${homerDir} -preparsedDir ${homerDir}
        """
      }
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
    findMotifsGenome.pl ${subjectRegionsFile} hg38 ${homerDir} -size ${params.size} -mask -preparsedDir ${homerDir} -find ${allMotifs} > peaks_motif.tsv
    """
}
process findTFmotifs {
    
    publishDir params.homerResults, mode: 'copy'

    input:
    file "peaks_motif.tsv"
    file tfList

    output:
    file tfList
    file "keyTF_motifs_in_peaks.csv"

    script:
    """
    ln -s "${params.bin}/find_relevant_motifs.py" .
    python find_relevant_motifs.py ${tfList} peaks_motif.tsv
    """
}
process convertOutputFormat {
    
    publishDir params.homerResults, mode: 'copy'

    input:
    file tfList
    file "keyTF_motifs_in_peaks.csv"
    file subjectRegionsFile

    output:
    file "homer_TFBS_results.prq"

    script:
    """
    ln -s "${params.bin}/convert_output_to_final_format.R" .
    Rscript convert_output_to_final_format.R keyTF_motifs_in_peaks.csv ${subjectRegionsFile}
    """
}
process writeLogFile {
    
    publishDir params.homerResults, mode: 'copy'

    input:

    output:
    file "logFile.txt"

    script:
    """
    touch "logFile.txt"
    echo "background file: ${params.backgroundBed}" > "logFile.txt"
    echo "subject file: ${params.subjectBed}" >> "logFile.txt"
    echo "tf list file: ${params.tfListFile}" >> "logFile.txt"
    echo "size: ${params.size}" >> "logFile.txt"
    """
}

workflow {
    def subjectRegions = Channel.fromPath(params.subjectBed)
    if (params.backgroundBed) {
        def backgroundRegions = Channel.fromPath(params.backgroundBed)
        initHomer = runInitialHomer(subjectRegions, backgroundRegions, params.homerResults)
    } else {
        initHomer = runInitialHomer(subjectRegions, params.backgroundBed, params.homerResults)
    }
    concatHomer = catHomerResults(initHomer)
    peaksMotifFile = runHomerInPeaks(subjectRegions, params.homerResults, concatHomer)
    def tfList = Channel.fromPath(params.tfListFile)
    convertOutputFormat(findTFmotifs(peaksMotifFile, tfList), subjectRegions)
    writeLogFile()
}
