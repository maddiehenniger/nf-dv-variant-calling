include { samtools_sort  } from '../modules/samtools_sort.nf'
include { picard_merge_sam_files } from '../modules/picard_mergesamfiles.nf'

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
        picard_merge_sam_files(
            ch_sorted_samples
        )

        ch_picardMergedBams = picard_merge_sam_files.out.picardMergedBams

        // Run Picard MarkDuplicates

    emit:
        sorted_samples  = ch_sorted_samples
        picardMergedBams = ch_picardMergedBams
}