task dellyCall{
    File inputBAM
    Int threads
    File reference
    File index
    String type
    String sampleName

    command{
        export OMP_NUM_THREADS=${threads} && delly call --type ${type} -g ${reference} -o ${sampleName}.${type}.bcf ${inputBAM}
    }

    runtime{
        docker : "erictdawson/svdocker"
        memory : "40 GB"
        cpu : "${threads}"
        disks : "local-disk 1000 HDD"
    }

    output{
        File xbcf = "${sampleName}.${type}.bcf"
    }
}

task vcflibMerge{
    File insBCF
    File invBCF
    File delBCF
    String sampleName

    command {
        bcftools view ${insBCF} > ${sampleName}.delly.ins.vcf
        bcftools view ${invBCF} > ${sampleName}.delly.inv.vcf
        bcftools view ${delBCF} > ${sampleName}.delly.del.vcf
        vcfcombine ${sampleName}.delly.ins.vcf ${sampleName}.delly.inv.vcf ${sampleName}.delly.del.vcf > ${sampleName}.merged.delly.vcf
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
    File index
    File reference
    Int threads
    String name
    
    call dellyCall as insCall{
        input:
           inputBAM=inputBAM,
           reference=reference,
           index=index,
           threads=threads,
           type="INS",
           sampleName=name
    }

    call dellyCall as invCall{
        input:
           inputBAM=inputBAM,
           reference=reference,
           index=index,
           threads=threads,
           type="INV",
           sampleName=name
    }

    call dellyCall as delCall{
        input:
           inputBAM=inputBAM,
           reference=reference,
           index=index,
           type="DEL",
           threads=threads,
           sampleName=name
    }

    call vcflibMerge{
        input:
            insBCF=insCall.xbcf,
            delBCF=delCall.xbcf,
            invBCF=insCall.xbcf,
            sampleName=name
        }
    }

