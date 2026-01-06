include { Filter_and_Trim } from "../subworkflows/run_trimming.nf"

workflow FILTER_AND_TRIM {
    take:
        samples
        adapters

    main:
        Filter_and_Trim(
            samples,
            adapters
        )

        ch_filteredSamples = Filter_and_Trim.out.filteredSamples


    emit:
        filteredSamples = ch_filteredSamples
}