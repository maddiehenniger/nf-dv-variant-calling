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

workflow Quality_Check {
    take:
        samples // channel (required): [ metadata, [ forwardPath, reversePath ] ]
    
    main:
        // Run FASTQC
        fastqc_stats(
            samples
        )

        ch_fastqc_output = fastqc_stats.out.fastqcResults

        // Run MultiQC
        multiqc_stats(
            ch_fastqc_output
        )

        ch_multiqc_output = multiqc_stats.out.multiqcResults

    emit:
        fastqc_output  = ch_fastqc_output
        multiqc_output = ch_multiqc_output
}