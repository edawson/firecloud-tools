task runWhamg{
    File bamFile
    File reference
    File referenceIndex
    #Array[String] keepRegions
    Int threads
    String sampleName

    #String regStr = join(keepRegions, '_')
    String regStr = ""
    String fin_str = "${sampleName}.${regStr}"
    
    runtime{
        docker : "erictdawson/svdocker"
        cpu : "${threads}"
        memory : "24 GB"
        disks : "local-disk 1000 HDD"
    }

    command {
        #whamg -f ${bamFile} -a ${reference} -e ${sep=',' keepRegions} -x ${threads} > ${fin_str}.wham.vcf
        whamg -f ${bamFile} -a ${reference} -x ${threads} > ${fin_str}.wham.vcf
    }

    output {
        File calls = "${fin_str}.wham.vcf"
    }
}

workflow whamFULL{
    File bamFile
    File reference
    File referenceIndex
    String sampleName
    #Array[String] keepRegions
    Int threads

    call runWhamg{
        input : bamFile = bamFile,
        sampleName = sampleName,
        reference = reference,
        referenceIndex = referenceIndex,
     #   keepRegions = keepRegions,
        threads = threads
    }
}
