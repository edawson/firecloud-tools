task mergeBrmBamsTask{
    Array[File] brmBAMs
    String outBase

    Array[String] inputTokens = prefix("I=", brmBAMs)

    command {
        bammerge ${sep=' ' inputTokens} > ${outBase}.merged.brm.bam
    }

    runtime{
        docker : "erictdawson/cgp-docker"
        cpu : 1
        memory : "18 GB"
        preemptible : 2
        disks : "local-disk 1000 HDD"
    }

    output{
        File mergedBRMBAM = "${outBase}.merged.brm.bam"
    }
}

task brassGroupTask{
    File mergedBrmBAM
    File outBase

    command {
        brass-group ${mergedBrmBAM} -o ${outBase}.brass_PON.groups
    }

    runtime{
        docker : "erictdawson/cgp-docker"
        cpu : 1
        memory : "100 GB"
        preemptible : 2
        disks : "local-disk 1000 HDD"
    }

    output{
        File brassGroupGZ = "${outBase}.brass_PON.groups.gz"
    }
}

task bgzipAndTabixTask{
    File brassPONGroupsGZ
    File outBase
    command{
        ( zgrep '^#' ${brassPONGroupsGZ};\
        zcat ${brassPONGroupsGZ} | \
        perl -ane 'next if ($_=~/^#/); printf "%s%s%s%s\t%s\n", $F[0],$F[1],$F[4],$F[5],join("\t",@F[1..$#F]);' | \
        sort -k1,1 -k3,3n -k4,4n -k7,7n -k8,8n ) > ${outBase}.brass.srt.groups && \
        bgzip -c ${outBase}.brass.srt.groups > ${outBase}.brass.srt.groups.gz && \
        tabix -s 1 -b 3 -e 4 -0 ${outBase}.brass.srt.groups.gz
    }

    runtime{
        docker : "erictdawson/cgp-docker"
        cpu : 1
        memory : "14 GB"
        preemptible : 4
        disks : "local-disks 1000 HDD"
    }

    output{
        File brassPONGZ = "${outBase}.brass.srt.groups.gz"
        File brassPONTBI = "${outBase}.brass.srt.groups.gz.tbi"
    }
}

workflow generateBrassFilterFile{
    Array[File] normalBRMs
    String outBase

    call mergeBrmBamsTask{
        input:
            brmBAMs=normalBRMs,
            outBase=outBase
    }


}




