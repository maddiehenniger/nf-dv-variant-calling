/**
 * Process to run Picard MergeSamFiles.
 * 
 * Merges sorted BAM files.
 * @see https://gatk.broadinstitute.org/hc/en-us/articles/360037053552-MergeSamFiles-Picard
 * 
 * @input sortedBams  - Channel consisting of [ meta, [ sortedBams ] ]
 * @emit picardMergedBam - Channel consisting of [ meta, [ picardMergedBams ] ]
 */

 process picard_merge_sam_files {
    tag "${meta.id}"

    label 'picard'

    label 'med_cpu'
    label 'dynamic_mem'
    label 'big_time'

    publishDir(
        path:    "${params.publishDirData}/postprocessed_aligned/",
        mode:    'symlink'
    )

    input:
        tuple val(meta), path(sortedBams)

    output:
        tuple val(meta), path("${meta.id}.sorted.picard.merged.bam"), emit: picardMergedBams

    script:
    // Create the input arguments string for Picard from the list of input BAMs
    def inputBams = sortedBams.collect { "I=$it" }.join(' ')

    """
    export _JAVA_OPTIONS="-Xmx20g"

    picard MergeSamFiles ${inputBams} \
    OUTPUT=${meta.id}.sorted.picard.merged.bam \
    USE_THREADING=TRUE MERGE_SEQUENCE_DIRECTORIES=TRUE ASSUME_SORTED=TRUE \
    VALIDATION_STRINGENCY=LENIENT TMP_DIR=${params.publishDirData}/postprocessed_aligned/tmp
     """
 }