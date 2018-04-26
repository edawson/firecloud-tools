task telomerecat_bam2telbam_TASK{
    File sampleBAM
    String sampleNAME
    String outname = basename(sampleBAM, ".bam") + "_telbam.bam"
   
    runtime{
        docker : "erictdawson/svdocker:latest"
        memory : "12GB"
        cpu : "8"
        disks : "local-disk 1000 HDD"
    }

    command <<<
        telomerecat bam2telbam -p 8  ${sampleBAM}
    >>>

    output{
        File telomerecat_telbam = "${outname}"
    }
}

task telomerecat_telbam2length_TASK{
    File telbam
    String sampleNAME
    String outname = basename(telbam, ".bam") + ".csv"

    runtime{
        docker : "erictdawson/svdocker:latest"
        memory : "12GB"
        cpu : "8"
        disks : "local-disk 200 hdd"
    }

    command <<<
        telomerecat telbam2length -p 8 ${telbam}
    >>>

    output{
        File telomerecat_csv = "${outname}"
    }
}

workflow TelomerecatWORKFLOW{
    File inputBAM
    String sampleNAME

    call telomerecat_bam2telbam_TASK{
        input:
            sampleNAME=sampleNAME,
            sampleBAM=inputBAM
    }

    call telomerecat_telbam2length_TASK{
        input:
            telbam=telomerecat_bam2telbam_TASK.telomerecat_telbam,
            sampleNAME=sampleNAME
    }
}
