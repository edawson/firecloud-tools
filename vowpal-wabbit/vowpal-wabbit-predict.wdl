task trainTask{
    File inputBam
    Int threads

    command {
        vw -
    }
    runtime {
        docker : "erictdawson/vowpal-wabbit"
        memory : "24 GB"
    }
    output{
        File sortedBAM="sorted.bam"
    }
}

workflow vwTrainModel {
    File inputBam
    Int threads
  
    call trainTask{
        input:
            inputBam=inputBam,
            threads=threads
    }
}
