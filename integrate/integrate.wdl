task detectFusions{

}

workflow runIntegrate{
    String sampleName
    File hitsRNABam
    File tumorDNABam
    File normalDNABam
    File annotations
    File reference
    File unmappedRNABam
    
    call detectFusions{

    }
}
