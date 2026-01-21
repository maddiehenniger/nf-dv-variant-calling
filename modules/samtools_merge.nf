/**
 * Process to run samtools view on samples.
 * 
 * XX
 * @see https://www.htslib.org/doc/samtools-sort.html
 * 
 * @input picardMarkedDuplicates - Channel consisting of [ meta, [ picardMarkedDuplicates ] ]
 * @emit mergedSamples - Channel consisting of [ meta, [ mergedSamples ] ]
 */

 process samtools_view {
    
    label 'samtools'

    label 'huge_cpu'
    label 'def_mem'
    label 'big_time'

    publishDir(
        path:    "${params.publishDirData}/final_samples/",
        mode:    "copy"
    )

    input:
        tuple val(meta), path(picardMarkedDuplicates)

    output:
        tuple val(meta), path("*bam"), emit: mergedBams

    script:
        """
        samtools view -@ ${task.cpus} -b --output-fmt-option level=9 -o ${meta.id}.bam ${picardMarkedDuplicates}
        """
 }