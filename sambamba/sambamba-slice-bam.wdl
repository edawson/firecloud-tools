task bambaSliceTask{
    File inputBam
    File bamIndex
    String contig

    # <${contigFile} xargs -n 1 -P 4 -tl -i{} sambamba slice -o {}.slice.bam ${inputBam} {}
    command {
        sambamba slice -o ${contig}.slice.bam ${inputBam} ${contig}
    }
    runtime {
        docker : "erictdawson/sambamba"
    }
    output{
        File BAMslices="${contig}.slice.bam"
    }
}

task bambaSliceFileTask{
    File inputBam
    File bamIndex
    File contigFile

    # <${contigFile} xargs -n 1 -P 4 -tl -i{} sambamba slice -o {}.slice.bam ${inputBam} {}
    command {
        for i in `cat ${contigFile}`
        do
            sambamba slice -o $i.slice.bam ${inputBam} $i
        done
    }
    runtime {
        docker : "erictdawson/sambamba"
    }
    output{
        Array[File] BAMslices=glob("*.slice.bam")
    }
}

workflow sambambaSlice{
    File inputBam
    File bamIndex
    File contigFile
   
        call bambaSliceFileTask{
            input:
                inputBam=inputBam,
                contigFile=contigFile,
                bamIndex=bamIndex
        }
}
