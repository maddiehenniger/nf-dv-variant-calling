include { Parse_Samplesheet  } from "../subworkflows/parse_samplesheet.nf"
include { Prepare_References } from "../subworkflows/prepare_references.nf"

workflow INITIAL_QC {
    take:
        samplesheet
        reference

    main:
        
        // Parse input samplesheet
        Parse_Samplesheet(
            samplesheet
        )

        ch_samples = Parse_Samplesheet.out.samples
        
        // Prepare reference genome
        Prepare_References(
            reference
        )

        ch_referenceFiles = Prepare_References.out.referenceFiles

    emit:
        samples        = ch_samples
        referenceFiles = ch_referenceFiles
}