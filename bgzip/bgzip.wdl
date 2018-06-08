task BGZIP{
    File inputFile
    
    String unz = basename(inputFile, ".gz")
    String sorted = basename(unz, ".vcf") + ".sorted.vcf"
    String zipped = basename(sorted, ".vcf") + ".vcf.gz"
    String tabi = zipped + ".tbi"
    
    command <<<
    if [[ ${inputFile} =~ \.gz$ ]]
        then gunzip -c -f ${inputFile} > ${unz}
    else
        cat ${inputFile} > ${unz}
    fi && \
    /usr/local/bin/vcfsort.sh ${unz} > ${sorted} && \
    bgzip ${sorted} && \
    tabix -f ${zipped}
    >>>
    
    runtime{
        docker : "erictdawson/svdocker"
        cpu : "4"
        mem : "14GB"
        disks : "local-disk 120 HDD"
    }

    output{
        File bgzippedVCF = "${zipped}"
        File vcfIndex = "${tabi}"
    }



}

workflow bgzipWF{
    File inputFile

    call BGZIP{
        input:
        inputFile=inputFile
    }
}
