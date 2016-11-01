
task getDiscordants{
    File inputBam
    Int threads
    command{
        samtools view -h -@ ${threads} -F 1294 -u -b -h  ${inputBam} > ${inputBam}.temp && \
        samtools sort -@ ${threads} -m 3G ${inputBam}.temp > ${inputBam}.discords.bam && rm ${inputBam}.temp
    }
    runtime{
        docker : "erictdawson/lumpy-sv"
    }
    output {
        File discordsBam="${inputBam}.discords.bam"
    }
}

task getSplits{
    File bamToSplits
    Int threads
    command {
        samtools view -h -@ ${threads} ${bamToSplits} | \
        /app/lumpy-sv/scripts/extractSplitReads_BwaMem -i stdin | \
        samtools view -@ ${threads} -b -u - > ${bamToSplits}.temp && \
        samtools sort -@ ${threads} -m 3G ${bamToSplits}.temp > ${bamToSplits}.splits.bam && rm ${bamToSplits}.temp
    }
    runtime{
        docker : "erictdawson/lumpy-sv"
    }
    output {
        File splitsBam="${bamToSplits}.splits.bam"
    }
}

task lumpyexpress{
    File inputBam
    File bamSplits
    File bamDiscords
    Int threads

    command {
        lumpyexpress -B ${inputBam} -P -t ${threads} -S ${bamSplits} -D ${bamDiscords}
    }
    runtime {
        docker : "erictdawson/lumpy-sv"
    }
    output{
        File outVCF="${inputBam}.vcf"
    }
}

workflow lumpyexpressFULL {
    File inputBam
    Int threads
   
    call getDiscordants{
        input:
            inputBam=inputBam,
            threads=threads
    }

    call getSplits{
        input:
            bamToSplits=inputBam,
            threads=threads
    }

    call lumpyexpress{
        input:
            inputBam=inputBam,
            threads=threads,
            bamSplits=getSplits.splitsBam,
            bamDiscords=getDiscordants.discordsBam
    }
}
