task dellyCall{
    File inputBAM
    Int threads
    File reference
    String type
    String sampleName

    command{
        delly call -t $type -g $reference -o ${sampleName}.dels.bcf $inputBAM
    }

    runtime{
        docker : "erictdawson/svdocker"
        memory : "40 GB"
        cpu : "${threads}"
        disks : "local-disk 1000 HDD"
    }
}

task vcflibMerge{
    File insVCF
    File invVCF
    File delVCF
    String sampleName

    command {
        vcfmerge ${sep=" -V " inputVCFs} > ${sampleName}.merged.delly.vcf
    }

    runtime {
        docker : "erictdawson/svdocker"
        memory : "16GB"
        cpu : "1"
        disks : "local-disk 500 HDD"
    }
    output{
        File merged = "${sampleName}.merged.svcalls.vcf"
    }
}



workflow dellyAll{
    File inputBAM
    File reference
    Int threads
    
    call dellyCall as insCall{
        input:
           inputBAM=inputBAM,
           reference=reference,
           type="INS"
           sampleName=`basename $inputBAM .bam`
    }

    call dellyCall as invCall{
        input:
           inputBAM=inputBAM,
           reference=reference,
           type="INV"
           sampleName=`basename $inputBAM .bam`
    }

    call dellyCall as delCall{
        input:
           inputBAM=inputBAM,
           reference=reference,
           type="DEL"
           sampleName=`basename $inputBAM .bam`
    }

    call vcflibMerge{
        input{
            insVCF=insCall.
            delVCF=delCall.
            invVCF=insCall.
            sampleName=`basename $inputBam .bam`
        }
    }

}
