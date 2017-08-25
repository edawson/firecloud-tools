task svabaCall{
    File tumorBAM
    #File tumorIndex
    File normalBAM
    #File normalIndex
    File reference
    String id
    Int threads
    File regions
#    File dbSNPVCF

    runtime{
        docker : "erictdawson/svdocker"
        memory : "110 GB"
        cpu : "${threads}"
        disks : "local-disk 1000 HDD"
    }

    command{
        svaba run -p ${threads} -t ${tumorBAM} -n ${normalBAM} --hp -G ${reference} -k ${regions} -a ${id}
    }

}

workflow svabaSomatic{
    File tumorBAM
    #File tumorIndex
    File normalBAM
    #File normalIndex
    File reference
    File refIndex
    String id
    Int threads
    File regions
    #File dbSNPVCF

    call svabaCall{
        input:
            tumorBAM=tumorBAM,
            normalBAM=normalBAM,
            reference=reference,
            id=id,
            threads=threads,
            regions=regions
            #dbSNPVCF=dbSNPVCF
    }

}
