task getDiscordants{
    File inputBam
        Int threads
        command{

            sambamba view -f bam -l 0 -F "unmapped and mate_is_unmapped and proper_pair and secondary_alignment and duplicate" -t ${threads} ${inputBam} | sambamba sort -t ${threads} -o /dev/stdout /dev/stdin > discords.bam
        }
    runtime{
docker : "erictdawson/sambamba"
    }
    output {
        File discordsBam="discords.bam"
    }
}

task getSplits{
    File bamToSplits
        Int threads
        command {
            sambamba view -h -t ${threads} ${bamToSplits} |
                /app/lumpy-sv/scripts/extractSplitReads_BwaMem -i stdin | \
                sambamba view -f bam -l 0 -t ${threads} -o /dev/stdout /dev/stdin | \
                sambamba sort -t ${threads} -o /dev/stdout /dev/stdin > splits.bam
        }
    runtime{
docker : "erictdawson/lumpy-sv"
    }
    output {
        File splitsBam="splits.bam"
    }
}

workflow prelumpy{
    File inputBam
    Int threads
}
