task lumpyexpress{
    File inputBam
    File bamSplits
    File bamDiscords
    Int threads

    command {
        lumpyexpress -B ${inputBam} -t ${threads} -S ${bamSplits} -D ${bamDiscords} -o calls.vcf
    }
    runtime {
        docker : "erictdawson/lumpy-sv"
    }
    output{
        File outVCF="calls.vcf"
    }
}

workflow lumpyexpressFULL {
    File inputBam
    File bamDiscord
    File bamSplits
    Int threads
  
    call lumpyexpress{
        input:
            inputBam=inputBam,
            bamSplits=bamSplits,
            bamDiscords=bamDiscords,
            threads=threads,
            bamSplits=getSplits.splitsBam,
            bamDiscords=getDiscordants.discordsBam
    }
}
