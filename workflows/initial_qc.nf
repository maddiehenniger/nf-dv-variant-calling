include { Parse_Samplesheet } from "../subworkflows/parse_samplesheet.nf"
// include { Quality_Check     } from "../subworkflows/quality_check.nf"

workflow INITIAL_QC {
    take:
        samplesheet

    main:
        Parse_Samplesheet(
            samplesheet
        )

        ch_samples = Parse_Samplesheet.out.samples
        
        // Quality_Check(
        //     ch_samples
        // )

        // ch_multiqc_results = Quality_Check.out.multiqc_output

    emit:
        samples = ch_samples
        // multiqc_results = ch_multiqc_results
}