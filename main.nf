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

workflow {

    // INITIAL_QC performs the following: 
    // 1) Reads in the samplesheet

    INITIAL_QC(
        file(params.samplesheet)       // required: User-provided path to sample metadata identified in the nextflow.config file 
    )

    ch_samples = INITIAL_QC.out.samples
        .view()

}