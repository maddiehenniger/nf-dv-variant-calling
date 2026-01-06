include { fastqc_stats  } from '../modules/fastqc.nf'
include { multiqc_stats } from '../modules/multiqc.nf'

/**
 * Perform quality check on samples by running FASTQC followed by MultiQC.
 * 
 * Outputs FASTQC HTML files per sample and MultiQC aggregates FASTQC HTML outputs to produce one statistic summary file.
 *
 * @take samplesheet - File object to input samplesheet as defined in the configuration file.
 * @emit samples - channel of input datasheets of shape [ metadata, [ forwardPath, reversePath ] ]
 **/

workflow Filter_and_Trim {
    take:
        samples // channel (required): [ metadata, [ forwardPath, reversePath ] ]
        adapters // file (required): containing adapter sequences to remove
    
    main:

        // Run Trimmomatic
        run_trimmomatic(
            samples,
            adapters
        )

        ch_filteredSamples = run_trimmomatic.out.trimmed

    emit:
        filteredSamples = ch_filteredSamples
}