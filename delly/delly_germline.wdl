task runDellyDEL{
    File inputBAM
    Int threads
    File excludes
    File reference
    String type

    command{
        delly call -t $type -g $reference -o `basename $inputBAM .bam`.dels.bcf $inputBAM
    }

    runtime{
        docker : "erictdawson/svdocker"
        memory : "40 GB"
        cpu : "${threads}"
        disks : "local-disk 1000 HDD"
    }
}

task runDellyINS{
    File inputBAM
    Int threads
    File excludes
    File reference
    String type

    command{
        delly call -t $type -g $reference -o out.bcf $inputBAM
    }

    runtime{
        docker : "erictdawson/svdocker"
        memory : "40 GB"
        cpu : "${threads}"
        disks : "local-disk 1000 HDD"
    }
}

task runDellyINV{
    File inputBAM
    Int threads
    File excludes
    File reference
    String type

    command{
        delly call -t $type -g $reference -o out.bcf $inputBAM
    }

    runtime{
        docker : "erictdawson/svdocker"
        memory : "40 GB"
        cpu : "${threads}"
        disks : "local-disk 1000 HDD"
    }
}

workflow dellyAll{

}
