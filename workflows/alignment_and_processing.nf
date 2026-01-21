include { Align_to_Reference } from "../subworkflows/align_to_ref.nf"
include { Process_Aligned_Samples } from "../subworkflows/sort_merge_mark_duplicates.nf"

workflow ALIGN_AND_PROCESS {
    take:
        filteredSamples
        referenceFiles

    main:
        Align_to_Reference(
            filteredSamples,
            referenceFiles
        )

        ch_alignedSamples = Align_to_Reference.out.alignedSamples

        Process_Aligned_Samples(
            ch_alignedSamples
        )

        ch_indexed_samples = Process_Aligned_Samples.out.indexedSamples

    emit:
        alignedSamples = ch_alignedSamples
        // markedDuplicates = ch_picard_marked_duplicates
        mergedSamples = Process_Aligned_Samples.out.mergedBams
        indexedSamples = ch_indexed_samples
}