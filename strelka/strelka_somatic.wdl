task strelkaSomaticTask{
    File reference
    File referenceIndex
    File tumorBam
    File tumorIndex
    File normalBam
    File normalIndex
    Int threads
    String name
    String tmpDIR = "strelkaTMP_" + name

   command{
       mkdir ${tmpDIR} && /usr/bin/bin/configureStrelkaSomaticWorkflow.py \
            --normalBam ${normalBam} \
            --tumorBam ${tumorBam} \
            --referenceFasta ${reference} \
            --runDir ${tmpDIR} && \
            ${tmpDIR}/runWorkflow.py -m local -j ${threads} && \
            mv ${tmpDIR}/results/variants/somatic.snvs.vcf.gz ${name}.strelka.somatic.snvs.vcf.gz && \
             mv ${tmpDIR}/results/variants/somatic.indels.vcf.gz ${name}.strelka.somatic.indels.vcf.gz

   }

    runtime{
        docker : "erictdawson/svdocker:latest"
        memory : "118GB"
        cpu : "${threads}"
        disks : "local-disk 1000 HDD"
    }

    output {
        File strelkaSomaticSNVs = "${name}.strelka.somatic.snvs.vcf.gz"
        File strelkaSomaticIndels = "${name}.strelka.somatic.indels.vcf.gz"
        #File strelkaStats = "${tmpDIR}/results/stats/genomeCallStats.tsv"
    }

}

task strelkaGermlineTask{
    File reference
    File referenceIndex
    File normalBam
    File normalIndex
    Int threads
    String name
    String tmpDIR = "strelkaTMP_" + name

    command{
        mkdir ${tmpDIR} && /usr/bin/bin/configureStrelkaGermlineWorkflow.py \
            --bam ${normalBam} \
            --referenceFasta ${reference} \
            --runDir ${tmpDIR} && \
            ${tmpDIR}/runWorkflow.py -m local -j ${threads} && \
            mv ${tmpDIR}/results/variants/variants.vcf.gz ${name}.strelka.germline.vcf.gz && \
             mv ${tmpDIR}/results/variants/genome.S1.vcf.gz ${name}.strelka.genome.germline.gvcf.gz
    }
    
    runtime{
        docker : "erictdawson/svdocker:latest"
        memory : "118GB"
        cpu : "${threads}"
        disks : "local-disk 1000 HDD"
    }
    
    output{
        File strelkaGermlineVCF = "${name}.strelka.germline.vcf.gz"
    }
}

workflow strelkaFullWorkflow{
    File reference
    File referenceIndex
    File tumorBam
    File tumorIndex
    File normalBam
    File normalIndex
    Int threads
    String name

    call strelkaSomaticTask {
        input:
            reference=reference,
            referenceIndex=referenceIndex,
            tumorBam=tumorBam,
            tumorIndex=tumorIndex,
            normalBam=normalBam,
            normalIndex=normalIndex,
            threads=threads,
            name=name

    }

    call strelkaGermlineTask {
        input: 
         reference=reference,
         referenceIndex=referenceIndex,
         normalBam=normalBam,
         normalIndex=normalIndex,
         threads=threads,
         name=name
    }

}
