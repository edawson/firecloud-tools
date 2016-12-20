task getDiscordants{
    File inputBam
    Int threads
    command{
        samtools view -b -F 1294 ${inputBam} | sambamba sort -t ${threads} -o discords.bam /dev/stdin
    }
    runtime{
        docker : "erictdawson/lumpy-sv"
	cpu : "${threads}"
	memory : "40 GB"
	disks : "local-disk 1000 HDD"
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
        sambamba sort -t ${threads} -o splits.bam /dev/stdin; find .
    }
    runtime{
        docker : "erictdawson/lumpy-sv"
	cpu : "${threads}"
	memory : "40 GB"
	disks : "local-disk 1000 HDD"
    }
    output {
        File splitsBam="splits.bam"
    }
}

task lumpyexpress{
    File inputBam
    File bamSplits
    File bamDiscords
    Int threads

    command <<<
        lumpyexpress -B ${inputBam} -t ${threads} -S ${bamSplits} -D ${bamDiscords} -o calls.vcf && \
        find `pwd` -iname "calls.vcf" -exec mv -vf  {}  . \;
        touch calls.vcf
    >>>
    runtime {
        docker : "erictdawson/lumpy-sv"
	cpu : "${threads}"
	memory : "40 GB"
	disks : "local-disk 1000 HDD"
    }
    output {
        File outVCF="calls.vcf"
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
