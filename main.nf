/*
---------------------------------------------------------------------
    maddiehenniger/nf-dv-variant-calling
---------------------------------------------------------------------
https://github.com/maddiehenniger/nf-dv-variant-calling
*/

nextflow.enable.dsl=2

/*
---------------------------------------------------------------------
    RUN MAIN WORKFLOW
---------------------------------------------------------------------
*/

// include custom workflows
include { INITIAL_QC } from "./workflows/initial_qc.nf"
include { FILTER_AND_TRIM } from "./workflows/filter_and_trim.nf"

workflow {

    // INITIAL_QC performs the following: 
    // 1) Reads in the samplesheet

    INITIAL_QC(
        file(params.samplesheet)       // required: User-provided path to sample metadata identified in the nextflow.config file 
    )

    ch_samples = INITIAL_QC.out.samples

    // FILTER_AND_TRIM performs the following:
    // 1) Runs Trimmomatic v0.40 to remove adapter sequences and filter quality

    FILTER_AND_TRIM(
        ch_samples,
        file(params.adapters)
    )

    ch_filteredSamples = FILTER_AND_TRIM.out.filteredSamples
        .view()

}