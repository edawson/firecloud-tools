
task MOSDEPTH_TASK{
    File inputBam
    File inputBai
    Int threads
    Int lowThreshold
    Int highThreshold

    String pref = basename(inputBam, ".bam")


    command <<<
    export MOSDEPTH_Q0=NO_COVERAGE &&
    export MOSDEPTH_Q1=LOW_COVERAGE &&
    export MOSDEPTH_Q2=CALLABLE   &&
    export MOSDEPTH_Q3=HIGH_COVERAGE &&
        mosdepth -t 4 --quantize 0:1:${lowThreshold}:${highThreshold} ${pref} ${inputBam}
    >>>

    runtime{
        docker : "erictdawson/svdocker:latest"
        cpu : 4
        memory : "16GB"
        disks : "local-disk 1000 HDD"
    }

    output{
        File mosdepth_quantized_depth = pref + ".quantized.bed.gz"
        File mosdepth_per_base_depth = pref + ".per-base.bed.gz"
        File mosdepth_global_depth_distribution = pref + ".mosdepth.global.dist.txt"
    }


}

workflow MOSDEPTH_WORKFLOW{
    File inputBam
    File inputBai
    Int threads
    Int lowThreshold
    Int highThreshold

    call MOSDEPTH_TASK{
        input:
            inputBam=inputBam,
            inputBai=inputBai,
            threads=threads,
            lowThreshold=lowThreshold,
            highThreshold=highThreshold
    }
    
}
