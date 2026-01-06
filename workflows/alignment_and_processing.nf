include { Align_to_Reference } from "../subworkflows/align_to_ref.nf"

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


    emit:
        alignedSamples = ch_alignedSamples
}