
task getDiscordants{
    File inputBam
    Int threads
    command{
    sambamba sort -F "unmapped and mate_is_unmapped and proper_pair and secondary_alignment and duplicate" -t ${threads} -o discords.bam ${inputBam}
    }
    runtime{
        docker : "erictdawson/lumpy-sv"
    }
    output {
        File discordsBam="discords.bam"
    }
}

task getSplits{
    File bamToSplits
    Int threads
    command {
        sambamba view -h -t ${threads} ${bamToSplits} | \
        /app/lumpy-sv/scripts/extractSplitReads_BwaMem -i stdin | \
        sambamba view -S -f bam -l 0 -t ${threads} -o /dev/stdout /dev/stdin | \
        sambamba sort -t ${threads} -o splits.bam /dev/stdin > splits.bam
    }
    runtime{
        docker : "erictdawson/lumpy-sv"
    }
    output {
        File splitsBam="splits.bam"
    }
}

task lumpyexpressPaired{
    File inputBamTumor
    File inputBamNormal
    File bamSplitsTumor
    File bamSplitsNormal
    File bamDiscordsTumor
    File bamDiscordsNormal
    Int threads

    command {
        lumpyexpress -B ${inputBamTumor},${inputBamNormal} -t ${threads} -S ${bamSplitsTumor},${bamSplitNormal} -D ${bamDiscordsTumor},${bamDiscordsTumor} -o calls.vcf
    }
    runtime {
        docker : "erictdawson/lumpy-sv"
    }
    output{
        File outVCF="tumorcalls.vcf"
    }
}

workflow lumpyexpressFULL {

    File inputBamTumor
    File inputBamNormal
    Int threads
   
    call getDiscordants{
        input:
            inputBam=inputBamNormal,
            threads=threads
    }

    call getSplits{
        input:
            bamToSplits=inputBamNormal,
            threads=threads
    }


    call getDiscordants{
        input:
            inputBam=inputBamTumor,
            threads=threads
    }

    call getSplits{
        input:
            bamToSplits=inputBamTumor,
            threads=threads
    }

    call lumpyexpress{
        input:
            inputBam=inputBam,
            threads=threads,
            bamSplitsTumor=getSplits.splitsBamTumor,
            bamSplitsNormal=getSplits.splitsBamNormal,
            bamDiscordsTumor=getDiscordants.discordsBamTumor
            bamDiscordsNormal=getDiscordants.discordsBamNormal
    }
}
