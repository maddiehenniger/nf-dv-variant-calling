include { bwa_mem2_mem } from '../modules/bwa_mem2_mem.nf'

/**
 * Perform quality check on samples by running FASTQC followed by MultiQC.
 * 
 * Outputs FASTQC HTML files per sample and MultiQC aggregates FASTQC HTML outputs to produce one statistic summary file.
 *
 * @take samplesheet - File object to input samplesheet as defined in the configuration file.
 * @emit samples - channel of input datasheets of shape [ metadata, [ forwardPath, reversePath ] ]
 **/

workflow Align_to_Reference {
    take:
        filteredSamples // channel (required): [ metadata, [ filteredForward, filteredReverse ] ]
        referenceFiles  // channel (generated): [ [reference, index1, index2, index3, index4, index5 ] ]

    main:
        // Run BWA-mem2 mem
        bwa_mem2_mem(
            filteredSamples,
            referenceFiles
        )

        ch_aligned = bwa_mem2_mem.out.alignedSamples

    emit:
        alignedSamples = ch_aligned
}