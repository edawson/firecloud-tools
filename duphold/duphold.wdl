task dupholdTASK{
    File inputBAM
    File inputBAI

    File inputVCFGZ
    File inputVCFTBI


    File FASTA
    File FAI

    String obase = basename(inputVCFGZ, ".vcf.gz")

    command{
        duphold -v ${inputVCFGZ} \
        -b ${inputBAM} -f ${FASTA} \
        -o ${obase}.dupholded.vcf -t 4 && 
        bgzip ${obase}.dupholded.vcf &&
        tabix ${obase}.dupholded.vcf.gz
    }

    runtime{
        docker : "erictdawson/duphold"
        cpu : 4
        memory : "16GB"
        disks : "local-disk 1000 HDD"
    }

    output{
        File dupholdAnnotatedVCFGZ = "${obase}.dupholded.vcf.gz"
        File dupholdAnnotatedVCFTBI = "${obase}.dupholded.vcf.gz.tbi"
    }

}

workflow dupholdWORKFLOW{
    File inputBAM
    File inputBAI

    File inputVCFGZ
    File inputVCFTBI

    File FASTA
    File FAI

    call dupholdTASK{
        input:
            inputBAM=inputBAM,
            inputBAI=inputBAI,
            inputVCFGZ=inputVCFGZ,
            inputVCFTBI=inputVCFTBI,
            FASTA=FASTA,
            FAI=FAI
    }
}
