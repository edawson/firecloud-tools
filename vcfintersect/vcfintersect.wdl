task Intersect{
    File firstVCF
    File firstIndex
    File secondVCF
    File secondIndex
    File ref
    File refIndex
    String samplename
    File bedFile

    String outname = samplename + ".intersection.vcf"
    

    command <<<
        vcfintersect -b ${bedFile} -m -r ${ref} -i ${firstVCF} ${secondVCF} > ${outname}
    >>>

    runtime{
        docker : "erictdawson/svdocker:latest"
        cpus : "1"
        memory : "100 GB"
        preemptible : 3
        bootDiskSizeGb: 14
        disks : "local-disk 120 HDD"
    }
    output{
        File intersectedVCF = "${outname}"
    }
}

workflow INTERSECT_VCFS{
    
    File firstVCF
    File firstIndex
    File secondVCF
    File secondIndex
    File ref
    File refIndex
    File bedFile
    String samplename

    call Intersect{
        input:
            firstVCF=firstVCF,
            firstIndex=firstIndex,
            secondVCF=secondVCF,
            secondIndex=secondIndex,
            samplename=samplename,
            ref=ref,
            refIndex=refIndex,
            bedFile=bedFile
    }
}
