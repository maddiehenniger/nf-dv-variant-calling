/**
 * Process to run Picard MarkDuplicates.
 * 
 * Locates and tags duplicate reads (defined as originating from a single fragment of DNA).
 * @see https://gatk.broadinstitute.org/hc/en-us/articles/360037052812-MarkDuplicates-Picard
 * 
 * @input picardMergedBam  - Channel consisting of [ meta, [ picardMergedBam ] ]
 * @emit picardMarkedDuplicates - Channel consisting of [ meta, [ picardMarkedDuplicates ] ]
 */

 process picard_mark_duplicates {
    
    label 'picard'

    label 'med_cpu'
    label 'big_mem'
    label 'big_time'

    publishDir(
        path:    "${params.publishDirData}/postprocessed_aligned/",
        mode:    'symlink'
    )

    input:
        tuple val(meta), path(picardMergedBams)

    output:
        tuple val(meta), path("${meta.id}.sorted.picard.merged.marked.bam"), emit: picardMarkedDuplicates

    script:
    """
    export _JAVA_OPTIONS="-Xmx50g"

    picard MarkDuplicates I=${picardMergedBams} \
    O=${meta.id}.sorted.picard.merged.marked.bam \
    -METRICS_FILE ${meta.id}.DUP.METRICS -MAX_RECORDS_IN_RAM 5000000 \
    -MAX_FILE_HANDLES_FOR_READ_ENDS_MAP 1000 -ASSUME_SORTED TRUE \
    -VALIDATION_STRINGENCY LENIENT -TMP_DIR ${params.publishDirData}/postprocessed_aligned/tmp \
    -OPTICAL_DUPLICATE_PIXEL_DISTANCE ${meta.pixel} -COMPRESSION_LEVEL 0
     """
 }