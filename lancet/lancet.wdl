task runLancet{
    Int threads
    File tumorBam
    File normalBam
    String sampleName
    String region
    File ref

    command {
        lancet --tumor ${tumorBam} --normal ${normalBam} --ref ${ref} --reg ${region} --num-threads ${threads} > ${sampleName}.lancet.vcf
    }

    runtime {
        docker : "erictdawson/svdocker"
        cpu : "${threads}"
        memory : "40 GB"
        disks : "local-disk 1000 HDD"
    }

    output{
        File calls="${sampleName}.lancet.vcf"
    }
}

workflow lancetFULL{
    File tumor
    File normal
    Int threads
    String name
    File regionFile
    File reference

    Array[File] regions = read_tsv(regionFile)

    scatter (reg in regions){
        call runLancet{
            input : sampleName = name,
                threads=threads,
                region = reg,
                tumorBam = tumor,
                normalBam = normal,
                ref = reference
        }
    }

}
