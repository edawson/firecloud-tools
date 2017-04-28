task runWhamg{
    File bamFile
    File bamIndex
    File reference
    File referenceIndex
    #Array[String] keepRegions
    Int threads
    String sampleName

    String regStr = ""
    String fin_str = "${sampleName}.${regStr}"
    
    runtime{
        docker : "erictdawson/svdocker"
        cpu : "${threads}"
        memory : "24 GB"
        disks : "local-disk 1000 HDD"
    }

    command {
        whamg -f ${bamFile} -a ${reference} -x ${threads} > ${fin_str}.wham.vcf
    }

    output {
        File calls = "${fin_str}.wham.vcf"
    }
}

workflow whamFULL{
    File bamFile
    File bamIndex
    File reference
    File referenceIndex
    String sampleName
    #Array[String] keepRegions
    Int threads

    call runWhamg{
        input :
            bamFile = bamFile,
            bamIndex = bamIndex,
            sampleName = sampleName,
            reference = reference,
            referenceIndex = referenceIndex,
            threads = threads
    }
}
