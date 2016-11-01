workflow lumpyexpress-full {
    File firstBam
    File secondBam
    Int threads

    task getDiscordants{
        command{
            sambamba view 
        }
        runtime{
            docker : "erictdawson/sambamba"
        }
        output {
            File discordsBam
        }
    }

    task getSplits{
        command {
            sambamba view
        }
        runtime{
            docker "erictdawson/sambamba"
        }
        output {
            splitsBam
        }
    }

    call getDiscordants{

    }

    call getSplits{

    }

    call lumpy-sv_task{

    }
}
