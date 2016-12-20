task bambaSortTask{
    File inputBam
    Int threads

    command {
        sambamba sort -m 20G -t ${threads} -o sorted.bam ${inputBam}
    }
    runtime {
        docker : "erictdawson/sambamba"
        memory : "24 GB"
    }
    output{
        File sortedBAM="sorted.bam"
    }
}

workflow sambambaSort {
    File inputBam
    Int threads
  
    call bambaSortTask{
        input:
            inputBam=inputBam,
            threads=threads
    }
}
