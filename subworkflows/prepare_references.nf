include { bwa_mem2_index } from '../modules/bwa_mem2_index.nf'

/**
 * Indexes the user-specified reference file.
 * 
 * Outputs the indexed reference files required by BWA to perform downstream sample alignment. 
 *
 * @take reference - A file path to the reference genome as defined in the configuration file.
 * @emit referenceFiles - channel of input datasheets of shape [ [ reference, index1, index2, index3, index4, index 5 ] ]
 **/

workflow Prepare_References {
    take:
        reference       // file (required): Path to indexed reference genome for alignment
    
    main:
        // Run BWA-mem2 index
        bwa_mem2_index(
            reference
        )

        ch_referenceFiles = bwa_mem2_index.out.referenceFiles

    emit:
        referenceFiles = ch_referenceFiles
}