task dellyCall{
    File tumorBAM
    File normalBAM
    Int threads
    File reference
    File tumorIndex
    File normalIndex
    String type
    String sampleName

    command{
        export OMP_NUM_THREADS=${threads} && delly call --type ${type}  -x /app/delly/excludeTemplates/human.hg19.excl.tsv -g ${reference} -o ${sampleName}.somatic.${type}.bcf ${tumorBAM} ${normalBAM}
    }

    runtime{
        docker : "erictdawson/svdocker"
        memory : "40 GB"
        cpu : "${threads}"
        disks : "local-disk 1000 HDD"
    }

    output{
        File xbcf = "${sampleName}.somatic.${type}.bcf"
    }
}



workflow dellyAll{
    File tumorBAM
    File normalBAM
    File tumorIndex
    File normalIndex
    File reference
    Int threads
    String name
        call dellyCall as bndCall{
        input:
           tumorBAM=tumorBAM,
           normalBAM=normalBAM,
           reference=reference,
           tumorIndex=tumorIndex,
           normalIndex=normalIndex,
           threads=threads,
           type="BND",
           sampleName=name
    }

    call dellyCall as traCall{
        input:
           tumorBAM=tumorBAM,
           normalBAM=normalBAM,
           reference=reference,
           tumorIndex=tumorIndex,
           normalIndex=normalIndex,
           type="TRA",
           threads=threads,
           sampleName=name
    }

    }

