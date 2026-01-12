include { bwa_mem2_index } from '../modules/bwa_mem2_index.nf'

/**
 * Indexes the user-specified reference file, or identifies if indices already exist.
 * 
 * Outputs the indexed reference files required by BWA to perform downstream sample alignment. 
 *
 * @take reference - A file path to the reference genome as defined in the configuration file.
 * @emit referenceFiles - channel of input datasheets of shape [ [ reference, index1, index2, index3, index4, index 5 ] ]
 **/

workflow Prepare_References {
    take:
        reference // file (required): Path to indexed reference genome for alignment
    
    main:
        // Identify the reference file object
        def ref_file = file(params.reference)
        
        // Define the required BWA-MEM2 index suffixes
        def index_suffices = ['.0123','.amb','.ann','.bwt.2bit.64','.pac']

        // This assumes indexes look like: ref.fa.amb, ref.fa.ann, etc.
        def expected_indices = index_suffixes.collect { suffix -> 
            file("${ref_file}${suffix}") 
        }

        // Check if the reference exists and if all indxed files are located within the same directory as the reference
        if (indices_exist) {
            log.info "Found existing BWA-MEM2 indices, skipping indexing."
            // Create a channel with the reference and the existing indices
            ch_referenceFiles = Channel.of([reference, expected_indices])
        } else {
            log.info "Indices not found. Starting indexing process. This is a highly memory-intensive task."
            // Run bwa index
            bwa_mem2_index(
                reference
            )
            // Create channel with the reference and generated indices
            ch_referenceFiles = bwa_mem2_index.out.referenceFiles

        }

    emit:
        referenceFiles = ch_referenceFiles
}