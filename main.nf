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
include { INITIAL_QC        } from "./workflows/initial_qc.nf"
include { FILTER_AND_TRIM   } from "./workflows/filter_and_trim.nf"
include { ALIGN_AND_PROCESS } from "./workflows/alignment_and_processing.nf"

workflow {

    // INITIAL_QC performs the following: 
    // 1a) Reads in the samplesheet and generates raw sample statistics
    // 1b) Reads in the reference and generates indexed files for downstream use
    INITIAL_QC(
        file(params.samplesheet)       // required: User-provided path to sample metadata identified in the nextflow.config file 
        file(params.reference)         // required: User-provided path to the reference genome to be used for alignment, as identified in the nextflow.config file
    )

    ch_samples = INITIAL_QC.out.samples
    ch_referenceFiles = INITIAL_QC.out.referenceFiles

    // FILTER_AND_TRIM performs the following:
    // 1) Runs Trimmomatic to remove adapter sequences and filter quality
    FILTER_AND_TRIM(
        ch_samples,
        file(params.adapters)
    )

    ch_filteredSamples = FILTER_AND_TRIM.out.filteredSamples

    // ALIGN_AND_PROCESS performs the following:
    // 1) Aligns samples to the user-defined reference genome using bwa-mem2 mem
    ALIGN_AND_PROCESS(
        ch_filteredSamples,
        ch_referenceFiles
    )

    ch_alignedSamples = ALIGN_AND_PROCESS.out.alignedSamples

}