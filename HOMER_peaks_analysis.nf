params.regionFile= ''
nextflow.enable.dsl=2


log.info """
        H O M E R    P I P E L I N E 
         regionFile: ${params.regionFile}
         """
         .stripIndent()


process HomerFindMotif {

   label "medium_slurm"
   publishDir paramas.outputDirHomer , mode: 'copy'

   input:

      path regionFile
   
   output:

      // path "result_${regionFile.simpleName}", emit: homerFolder
      path "${dirName}/allKnow.motif", emit: knownMotif
      path "${dirName}/homerMotifs.all.motifs", emit: novelMotif
   
   script:
      dirName = "${paramas.homerFolder}"
      known_motif = "${dirName}/allKnow.motif"
      homerRegion = "${regionFile.simpleName}.homer"
      """
      module load hurcs homer
      mkdir "$dirName"
      findMotifsGenome.pl $homerRegion hg38 "$dir_name" -preparsedDir "${params.homerTmp}"
      # Find and concatenate motif files
      find "${dirName}/knownResults" -type f -name "*.motif" -exec cat {} >> "${known_motif}" 
      """
}

process HomerRegion {

      input:

      path regionFile
   
   output:
      path "${regionFile.simpleName}.homer"
   
   script:

      homerRegion = "${regionFile.simpleName}.homer"
      """
      cp "$regionFile" "$homerRegion"
      """
}


process HomerFindPeaks {

   label "medium_slurm"
   publishDir paramas.outputDirHomer , mode: 'copy'

   input:

      path motifFile
      path homerRegion
      path dirname
   
   output:

      path "${motifFile.simpleName}_to_peak.tsv", emit: homerToPeak
   
   script:
      output = "${motifFile.simpleName}_to_peak.tsv"
      """
      module load hurcs homer
    
      findMotifsGenome.pl $homerRegion hg38 "$dir_name" -size 200 -mask -preparsedDir "${params.homerTmp}" -find "${motifFile}" > "${output}"
      """
}




workflow {
    bed-to-homer->HOMER-find-motif->create-file-for-finding->HOMER-find-in-peaks -> analysis
 
   params.homerTmp = "${params.tmpDir}/HOMER"
   paramas.homerFolder = "result_${regionFile.simpleName}"
   paramas.outputDirHomer = "${params.outputDir}/HOMER/${regionFile.simpleName}"



    myFile = file(params.pathFile)
    allLines = myFile.readLines()
    gz = Channel.fromList(allLines)

   // both = vcf.mix(gz)
   tbi = tbiVCF(gz)
    checked =checkHgVersion(tbi)
    processVCF(checked)
   
   //sample_file = processVCF(checkHgVersion(tbiVCF(gz).output_vcf)).sampleFile.collectFile()

    
}

