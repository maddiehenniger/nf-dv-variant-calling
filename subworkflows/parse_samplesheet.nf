include { samplesheetToList } from 'plugin/nf-schema'

/**
 * Parse the required and optional files provided in the Nextflow configuration file.
 * 
 * Validate and parse the input samplesheet with nf-schema `samplesheetToList`.
 * Wrangles the input datasets into the format of channels expected by downstream processes.
 *
 * @take samplesheet - File object to input samplesheet as defined in the configuration file.
 * @emit samples - channel of input datasheets of shape [ metadata, [ forwardPath, reversePath ] ]
 **/

workflow Parse_Samplesheet {
    take:
        samplesheet // channel (required): [ metadata, [ forwardPath, reversePath ] ]
    
    main:
        // Use nf-schema to handle input samples and associated metadata
        
        // Creates a channel that takes and validates the input samples
        Channel
            .fromList(
                samplesheetToList(samplesheet, "${projectDir}/assets/schema_samplesheet.json")
            )
            .map { meta, forwardPath, reversePath -> 
                tuple(meta, forwardPath, reversePath) 
            }
            .set { ch_samples }

    emit:
        samples = ch_samples
}