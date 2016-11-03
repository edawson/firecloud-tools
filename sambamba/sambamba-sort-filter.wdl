task bambaSortFilterTask{
    File inputBam
    Int threads
    String filterStr

    command {
        sambamba sort -m 20G -t ${threads} -F "${filterStr}" -o sorted.bam ${inputBam}
    }
    runtime {
        docker : "erictdawson/sambamba"
    }
    output{
        File sortedBAM="sorted.bam"
    }
}

workflow sambambaSortFilter {
    File inputBam
    Int threads
    String filterStr
  
    call bambaSortFilterTask{
        input:
            inputBam=inputBam,
            threads=threads,
            filterStr=filterStr
    }
}
