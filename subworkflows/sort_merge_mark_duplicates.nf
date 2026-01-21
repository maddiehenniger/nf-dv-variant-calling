include { samtools_sort          } from '../modules/samtools_sort.nf'
include { picard_merge_sam_files } from '../modules/picard_mergesamfiles.nf'
include { picard_mark_duplicates } from '../modules/picard_markduplicates.nf'
include { samtools_view } from '../modules/samtools_merge.nf'
include { samtools_index } from '../modules/samtools_index.nf'

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

        // Take the samtools sort output and restructure the metadata for samples with multiple sequencing libraries
        ch_sorted_samples = samtools_sort.out.sortedBams
            .map { meta, sortedBams ->
                def picard_meta = [
                    sampleID: meta.sampleID,
                    libraryID: meta.libraryID,
                    pixel: meta.pixel,
                    platformTechnology: meta.platformTechnology,
                    id: "${meta.sampleID}_${meta.libraryID}"
                ]
                return [ picard_meta, sortedBams ]
            }
        // Now group by the new index to collect samples together by library
        .groupTuple(by: 0)

        // Run Picard MergeSamFiles
        picard_merge_sam_files(
            ch_sorted_samples
        )

        ch_picard_merged_bams = picard_merge_sam_files.out.picardMergedBams

        // Run Picard MarkDuplicates
        picard_mark_duplicates(
            ch_picard_merged_bams
        )

        ch_picard_marked_duplicates = picard_mark_duplicates.out.picardMarkedDuplicates

        // Run samtools merge
        samtools_view(
            ch_picard_marked_duplicates
        )

        ch_merged_bams = samtools_view.out.mergedBams

        // Run samtools index
        samtools_index(
            ch_merged_bams
        )

        ch_indexed_samples = samtools_index.out.indexedSamples

    emit:
        sorted_samples  = ch_sorted_samples
        picardMergedBam = ch_picard_merged_bams
        picardMarkedDuplicates = ch_picard_marked_duplicates
        mergedBams = ch_merged_bams
        indexedSamples = ch_indexed_samples
}