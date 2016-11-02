task getDiscordantsT{
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

task getSplitsT{
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


task getDiscordantsN{
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

task getSplitsN{
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
        lumpyexpress -B ${inputBamTumor},${inputBamNormal} -t ${threads} -S ${bamSplitsTumor},${bamSplitsNormal} -D ${bamDiscordsTumor},${bamDiscordsTumor} -o tumor_calls.vcf
    }
    runtime {
        docker : "erictdawson/lumpy-sv"
    }
    output{
        File outVCF="tumor_calls.vcf"
    }
}

workflow lumpyexpressFULL {

    File inputBamTumor
    File inputBamNormal
    Int threads
   
    call getDiscordantsT{
        input:
            inputBam=inputBamTumor,
            threads=threads
    }

    call getSplitsT{
        input:
            bamToSplits=inputBamTumor,
            threads=threads
    }


    call getDiscordantsN{
        input:
            inputBam=inputBamNormal,
            threads=threads
    }

    call getSplitsN{
        input:
            bamToSplits=inputBamNormal,
            threads=threads
    }

    call lumpyexpressPaired{
        input:
            inputBamTumor=inputBamTumor,
            inputBamNormal=inputBamNormal,
            threads=threads,
            bamSplitsTumor=getSplitsT.splitsBam,
            bamSplitsNormal=getSplitsN.splitsBam,
            bamDiscordsTumor=getDiscordantsT.discordsBam,
            bamDiscordsNormal=getDiscordantsN.discordsBam
    }
}
