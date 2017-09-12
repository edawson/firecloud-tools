task pFBTask{
    File bamFile
        File bamIndex
        Int threads
        String id
        File reference
        File referenceIndex

        command {
            cd /app/freebayes/freebayes-parallel <(fasta_generate_regions.py ${reference} 100000) ${threads} -f ${reference} ${bamFile} > ${id}.freebayes.vcf
        }

    runtime {
        docker : "erictdawson/svdocker"
        memory : "28GB"
        cpu : "16"
        disks : "local-disk 1000 HDD"
    }

    output{
        File FBvcf = "${id}.freebayes.vcf"
    }
}

workflow FreeBayes{
    File bamFile
        File bamIndex
        Int threads
        String id
        File reference
        File referenceIndex

        call pFBTask{
            input:
            bamFile=bamFile,
                bamIndex=bamindex,
                threads=threads,
                id=id,
                reference=reference,
                referenceIndex=referenceIndex
        }

}
