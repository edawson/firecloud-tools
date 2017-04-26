task getDiscordants{
    File inputBam
    Int threads
    command {
        sambamba view -h -f bam --num-filter /1294 -o bambatmp.bam ${inputBam}  &&  sambamba sort -t ${threads} -o discords.bam bambatmp.bam
    }
    runtime{
        docker : "erictdawson/svdocker"
	cpu : "${threads}"
	memory : "24 GB"
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
        sambamba view -S -f bam -h -l 5 -t ${threads} -o /dev/stdout /dev/stdin | \
        sambamba sort -t ${threads} -o splits.bam /dev/stdin; find .
    }
    runtime{
        docker : "erictdawson/svdocker"
	cpu : "${threads}"
	memory : "24 GB"
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
    String sampleName

    command {
        lumpyexpress -B ${inputBam} -t ${threads} -S ${bamSplits} -D ${bamDiscords} -o ${sampleName}.lumpy.vcf
    }
    runtime {
        docker : "erictdawson/svdocker"
	    cpu : "${threads}"
	    memory : "60 GB"
	    disks : "local-disk 1000 HDD"
    }
    output {
        File outVCF="${sampleName}.lumpy.vcf"
    }
}


workflow lumpyexpressFULL {
    File inputBam
    Int threads
    String name

    call getDiscordants{
        input:
            inputBam=inputBam,
            threads=8
    }

    call getSplits{
        input:
            bamToSplits=inputBam,
            threads=8
    }

    call lumpyexpress{
        input:
            inputBam=inputBam,
            threads=threads,
            bamSplits=getSplits.splitsBam,
            bamDiscords=getDiscordants.discordsBam,
            sampleName=name
    }
    output {
        File calledVCF = lumpyexpress.outVCF
    }
}
