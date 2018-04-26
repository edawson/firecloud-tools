task bp2bed_task{
    File sampleMAF
    String samplename
    String outname = basename(samplename, ".maf") + "bed"
    
    runtime{
        docker : "erictdawson/svdocker"
        memory : "12 GB"
        cpu : "8"
        disks : "local-disk 1000 HDD"
    }


    command <<<
           cat $sampleMAF | python bp_to_bed.py > $outname 
    >>>

    output{
        File mafBED = "$outname"
    }
}

workflow BP2BED{
    File sampleMAF
    String samplename

    call bp2bed_task{
        input:
            sampleMAF=sampleMAF,
            samplename=samplename
    }
}
