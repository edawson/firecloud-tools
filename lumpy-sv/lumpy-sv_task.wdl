

task lumpy {
    File sampleBAM
    File splits
    File discords
    Int threads
    String outdir

    command {
        lumpy-express -B ${sampleBAM} \
        -S ${splits} -D S{discords} -v \
        -o ${outdir} -t ${threads}
    }

    output{
        File outVCF
    }

    runtime{
        docker : "erictdawson/lumpy-express-sv"
    }

    meta{
        author : "Eric T Dawson"
        email : "eric.t.dawson@gmail.com"

    }
}