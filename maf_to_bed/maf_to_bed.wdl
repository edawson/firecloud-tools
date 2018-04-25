task maf2bed_task{
    File sampleMAF
    String samplename
    
    runtime{
        docker : "erictdawson/svdocker"
        memory : "12 GB"
        cpu : "8"
        disks : "local-disk 1000 HDD"
    }


    command <<<
    
    >>>

    output{
        File reduced_bam = "$(basename sampleBAM .bam).${cov}X.bam"
    }
}

workflow MAF2BED{
    File sampleMAF
    String samplename

    call maf2bed_task{
        input:
            sampleMAF=sampleMAF,
            samplename=samplename
    }
}
