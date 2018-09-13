task dupholdTASK{
    File inputBAM
    File inputBAI

    File inputVCF
    File inputVCFIndex

    File FASTA
    File FAI

    String obase = basename(inputVCF, ".vcf")

    command{
        duphold --threads 4 --vcf ${inputVCF} \
        --bam ${inputBAM} --fasta $fasta \
        --output ${obase}.dupholded.vcf
    }

    runtime{
        docker : "erictdawson/duphold"
        cpu : 4
        memory : "16GB"
        disks : "local-disk 1000 HDD"
    }

    output{
        File dupholdAnnotatedVCF = "${obase}.dupholded.vcf"
    }

}

workflow dupholdWORKFLOW{
    File inputBAM
    File inputBAI

    File inputVCF
    File inputVCFIndex

    File FASTA
    File FAI

    call dupholdTASK{
        input:
            inputBAM=inputBAM,
            inputBAI=inputBAI,
            inputVCF=inputVCF,
            inputVCFIndex=inputVCFIndex,
            FASTA=FASTA,
            FAI=FAI
    }
}
