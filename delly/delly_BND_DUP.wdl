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

task vcflibMerge{
    File bndBCF
        File dupBCF
        String sampleName

        command {
            bcftools view ${bndBCF} > ${sampleName}.delly.somatic.bnd.vcf
                bcftools view ${dupBCF} > ${sampleName}.delly.somatic.dup.vcf
                vcfcombine ${sampleName}.delly.somatic.bnd.vcf ${sampleName}.delly.somatic.dup.vcf > ${sampleName}.bnd.dup.delly.somatic.vcf
        }

    runtime {
docker : "erictdawson/svdocker"
             memory : "16GB"
             cpu : "1"
             disks : "local-disk 1000 HDD"
    }
    output{
        File merged = "${sampleName}.bnd.dup.delly.somatic.vcf"
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
                type="BND",
                threads=threads,
                sampleName=name
        }

    call dellyCall as dupCall{
        input:
        tumorBAM=tumorBAM,
            normalBAM=normalBAM,
            reference=reference,
            tumorIndex=tumorIndex,
            normalIndex=normalIndex,
            type="DUP",
            threads=threads,
            sampleName=name
    }



    call vcflibMerge{
        input:
        bndBCF=bndCall.xbcf,
            dupBCF=dupCall.xbcf,
            sampleName=name
    }
}

