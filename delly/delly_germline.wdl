task dellyCall{
    File inputBAM
    Int threads
    File reference
    File inputIndex
    String type
    String sampleName

    command{
        export OMP_NUM_THREADS=${threads} && delly call --type ${type}  -x delly/excludeTemplates/human.hg19.excl.tsv -g ${reference} -o ${sampleName}.somatic.${type}.bcf ${inputBAM}
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
    File insBCF
    File invBCF
    File delBCF
    String sampleName

    command {
        bcftools view ${insBCF} > ${sampleName}.delly.somatic.ins.vcf
        bcftools view ${invBCF} > ${sampleName}.delly.somatic.inv.vcf
        bcftools view ${delBCF} > ${sampleName}.delly.somatic.del.vcf
        vcfcombine ${sampleName}.delly.somatic.ins.vcf ${sampleName}.delly.somatic.inv.vcf ${sampleName}.delly.somatic.del.vcf > ${sampleName}.inv.ins.del.delly.somatic.vcf
    }

    runtime {
        docker : "erictdawson/svdocker"
        memory : "16GB"
        cpu : "1"
        disks : "local-disk 1000 HDD"
    }
    output{
        File merged = "${sampleName}.merged.delly.vcf"
    }
}




workflow dellyAll{
    File inputBAM
    File inputIndex
    File reference
    Int threads
    String name
    
    call dellyCall as insCall{
        input:
           inputBAM=inputBAM,
           reference=reference,
           inputIndex=inputIndex,
           threads=threads,
           type="INS",
           sampleName=name
    }

    call dellyCall as invCall{
        input:
           inputBAM=inputBAM,
           reference=reference,
           inputIndex=inputIndex,
           threads=threads,
           type="INV",
           sampleName=name
    }

    call dellyCall as delCall{
        input:
           inputBAM=inputBAM,
           reference=reference,
           inputIndex=inputIndex,
           type="DEL",
           threads=threads,
           sampleName=name
    }

    call vcflibMerge{
        input:
            insBCF=insCall.xbcf,
            delBCF=delCall.xbcf,
            invBCF=invCall.xbcf,
            sampleName=name
        }
    }

