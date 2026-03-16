/**
 * Process to run samtools index on samples.
 * 
 * XX
 * @see https://www.htslib.org/doc/samtools-sort.html
 * 
 * @input mergedSamples - Channel consisting of [ meta, [ mergedSamples ] ]
 * @emit indexedSamples - Channel consisting of [ meta, [ indexedSamples ] ]
 */

 process samtools_index {
    
    label 'samtools'

    label 'def_cpu'
    label 'lil_mem'
    label 'med_time'

    publishDir(
        path:    "${params.publishDirData}/final_samples/",
        mode:    "copy"
    )

    input:
        tuple val(meta), path(mergedSamples)

    output:
        tuple val(meta), path("*bai"), emit: indexedSamples

    script:
        """
        samtools index \
        -@ ${task.cpus} \
        ${mergedSamples}
        """
 }