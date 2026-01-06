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
include { PREPARE_INPUTS                            } from "./workflows/prepare_inputs.nf"
include { PHASE_SAMPLES                             } from "./workflows/phase_samples.nf"
include { IMPUTE_SAMPLES as FIRST_ROUND_IMPUTATION  } from "./workflows/impute_samples.nf"
include { IMPUTE_SAMPLES as SECOND_ROUND_IMPUTATION } from "./workflows/impute_samples.nf"
// include { CALCULATE_ACCURACY } from "./workflows/calculate_accuracy.nf"

workflow {

    // PREPARE_INPUTS performs the following: 
    // 1) Reads in the test sample(s), references, and optionally provided paths to genetic maps specified in the nextflow.config file
    // 1A) Separates the reference panels based on the user-defined imputationStep ('one' for the first round of imputation, 'two' for second round of imputation)
    // 1B) Detects if the user has provided a path to the genetic maps for downstream use 
    // 2) Indexes the input sample(s), intermediate reference, and twostep reference
    // 3) Extracts the unique chromosome values from each sample and reference panel, storing the chromosome values for downstream phasing/imputation
    // 4) Separates the input test sample by chromosome and then indexes the split files
    // 5) Converts the references to XCF file format for downstream phasing and imputation 

    PREPARE_INPUTS(
        file(params.samplesheet),       // required: User-provided path to sample metadata identified in the nextflow.config file 
        file(params.references)         // required: User-provided path to the reference metadata identified in the nextflow.config file 
    )

    ch_prepare_phasing_samples    = PREPARE_INPUTS.out.prepare_phasing_samples
    ch_twostep_ref_xcf            = PREPARE_INPUTS.out.twostep_ref_xcf

}