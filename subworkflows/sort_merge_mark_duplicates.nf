include { samtools_sort  } from '../modules/samtools_sort.nf'

/**
 * Sorts the samples aligned to the reference genome, and then used Picard MergeSamFiles to merge. Duplicates are marked using Picard MarkDuplicates. Library-specific BAM files that consist of multiple sequencing libraries per sample are merged and indexed to produce a single BAM file using samtools.
 * 
 * Outputs a merged BAM file.
 *
 * @take samplesheet - File object to input samplesheet as defined in the configuration file.
 * @emit samples - channel of input datasheets of shape [ metadata, [ forwardPath, reversePath ] ]
 **/

workflow Process_Aligned_Samples {
    take:
        alignedSamples // channel (required): [ metadata, [ alignedSamples ] ]
    
    main:
        // Run samtools sort
        samtools_sort(
            alignedSamples
        )

        ch_sorted_samples = samtools_sort.out.sortedSamples

        // Run Picard MergeSamFiles
        multiqc_stats(
            ch_fastqc_output
        )

        ch_multiqc_output = multiqc_stats.out.multiqcResults

    emit:
        fastqc_output  = ch_fastqc_output
        multiqc_output = ch_multiqc_output
}