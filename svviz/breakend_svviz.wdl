task VIZTASK{
    File maf
    File ref
    File tumorBAM
    File controlBAM
    File tumorBAMIndex
    File controlBAMIndex
    String samplename
    
    runtime{
        docker : "erictdawson/svviz"
        memory : "59 GB"
        cpu : "8"
        disks : "local-disk 1000 HDD"
    }


    command <<<
        mkdir results_${samplename} && \
        for bk in `tail -n+2 ${maf} | cut -f 3,4,5,6,7,8 | sed "s/\t/,/g" | awk -F, '{print $1,$3,$2,$4,$6,$5}' OFS=','`; \
            do 
                svviz --export results_${samplename}/${samplename}.$(echo $bk | sed "s/,/_/g").pdf --format pdf --type $(python /usr/bin/maf_svtype.py $bk) --sample-reads 1000 --max-size 10000000 --max-deletion-size 5000 --min-mapq 40 --pair-min-mapq 60 --summary ${samplename}.summary.tsv -b ${tumorBAM} -b ${controlBAM} ${ref} $(python /usr/bin/maf_to_svviz.py $bk);
            done && \
        tar cvzf results_${samplename}.tgz results_${samplename}/
    >>>

    output{
        File image_tarball = "results_${samplename}.tgz"
    }
}

workflow svvizflow{
    File maf
    File ref
    File tumorBAM
    File tumorBAMIndex
    File controlBAM
    File controlBAMIndex
    String samplename

    call VIZTASK{
        input:
            maf=maf,
            ref=ref,
            tumorBAM=tumorBAM,
            controlBAM=controlBAM,
            tumorBAMIndex=tumorBAMIndex,
            controlBAMIndex=controlBAMIndex,
            samplename=samplename
    }
}
