task brassMainTask{
    File tumorBAM
    File tumorBAMBAS
    File tumorBAMIndex
    File normalBAM
    File normalBAMBAS
    File normalBAMIndex

    File filterFile

    File genomeFile
    File genomeFAIFile
    File hiSeqDepthFile
    File genomeCacheFile
    File viralSeqsFile
    Array[File] microbeSeqsFiles
    String microbeSeqsFilesPrefix
    String microbeSeqsDir
    File centroTeloFile
    File gcBinsFile
    File cytobandFile

    String species
    String assembly
    String protocol
    String sampleName

    command <<<
        #ddir=`pwd` && \
        #cd ${microbeSeqsDir} && \
        #ln -s *.2bit "$ddir" **\
        #cd "$ddir" && \
        mkdir results && \
        brass.pl \
        -outdir results \
        -tumour ${tumorBAM} \
        -normal ${normalBAM} \
        -depth ${hiSeqDepthFile} \
        -genome ${genomeFile} \
        -g_cache ${genomeCacheFile} \
        -species ${species} \
        -assembly ${assembly} \
        -protocol ${protocol} \
        -viral ${viralSeqsFile} \
        -microbe ${microbeSeqsFilesPrefix} \
        -cytoband ${cytobandFile} \
        -centtel ${centroTeloFile} \
        -gcbins ${gcBinsFile} \
        -cpus 4 && \
        tar czf results.${sampleName}.tgz results/
    >>>

    runtime{
        docker : "erictdawson/cgp-docker"
        cpus : "32"
        memory : "100 GB"
        disks : "local-disk 1500 HDD"
    }

    output{
        File brassResultsTarball = "results.${sampleName}.tgz"        
    }



}

workflow brassMainWorkflow{
    File tumorBAM
    File tumorBAMBAS
    File tumorBAMIndex
    File normalBAM
    File normalBAMBAS
    File normalBAMIndex

    File filterFile

    File genomeFile
    File genomeFAIFile
    File hiSeqDepthFile
    File genomeCacheFile
    File viralSeqsFile
    Array[File] microbeSeqsFiles
    String microbeSeqsFilesPrefix
    String microbeSeqsDir
    File centroTeloFile
    File gcBinsFile
    File cytobandFile

    String sampleName
    String species
    String assembly
    String protocol

    call brassMainTask{

    input:
       tumorBAM=tumorBAM,
       tumorBAMBAS=tumorBAMBAS,
       tumorBAMIndex=tumorBAMIndex,
       normalBAM=normalBAM,
       normalBAMBAS=normalBAMBAS,
       normalBAMIndex=normalBAMIndex,
       filterFile=filterFile,
       genomeFile=genomeFile,
       genomeFAIFile=genomeFAIFile,
       hiSeqDepthFile=hiSeqDepthFile,
       genomeCacheFile=genomeCacheFile,
       viralSeqsFile=viralSeqsFile,
       microbeSeqsFiles=microbeSeqsFiles,
       microbeSeqsFilesPrefix=microbeSeqsFilesPrefix,
       microbeSeqsDir=microbeSeqsDir,
       centroTeloFile=centroTeloFile,
       gcBinsFile=gcBinsFile,
       cytobandFile=cytobandFile,
       species=species,
       sampleName=sampleName,
       assembly=assembly,
       protocol=protocol
    }


}
