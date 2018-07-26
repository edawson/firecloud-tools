task generateBrassDiscordBam{
    File inputBAM
    File inputBAMIndex
    File inputBAMBas

    String iLocBAM = basename(inputBAM)
    String iLocBAI = basename(inputBAMIndex)
    String iLocBAS = basename(inputBAMBas)

    String resultsDirName = basename(inputBAM, ".bam")

    command {
        ln -s ${inputBAM} ${iLocBAM} && \
        ln -s ${inputBAMIndex} ${iLocBAI} && \
        ln -s ${inputBAMBas} ${iLocBAS} && \
        brassI_np_in.pl `pwd` 1 ${iLocBAM}
    }

    runtime{
        docker : "erictdawson/cgp-docker"
        cpu : 1
        memory : "3 GB"
        preemptible : 2
        disks : "local-disk 1000 HDD"
    }

    output{
        File brassBRMBAM = "${resultsDirName}/${resultsDirName}.brm.bam"
        File brassBRAMBAMIndex = "${resultsDirName}/${resultsDirName}.brm.bam.bai"
    }

}

workflow brassDiscordantReadsGenerator{
    File inputBAM
    File inputBAMIndex
    File inputBAMBas

    call generateBrassDiscordBam{
        input:
            inputBAM=inputBAM,
            inputBAMIndex=inputBAMIndex,
            inputBAMBas=inputBAMBas
    }
}
