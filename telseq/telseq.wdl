task TELSEQ_TASK{
    File inputBam
    File inputBai
    Int readLength
    String telseqOutName = basename(inputBam, ".bam") + ".telseq.txt"
    
    command <<<
        telseq -r ${readLength} -u ${inputBam} > ${telseqOutName}
    >>>

    runtime{
        docker : "erictdawson/svdocker:latest"
        cpu : 1
        memory : "12GB"
        bootDiskSizeGb: 12
        disks : "local-disk 1000 HDD"
    }

    output{
        File telseq_output = "${telseqOutName}"
    }
}

workflow TELSEQ{
    File inputBam
    File inputBai
    Int readLength

    call TELSEQ_TASK{
        input:
            inputBam=inputBam,
            inputBai=inputBai,
            readLength=readLength
        
    }

    output{
        File telseq_results = TELSEQ_TASK.telseq_output
    }

}
