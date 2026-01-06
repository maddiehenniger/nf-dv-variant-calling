/**
 * Process to run samtools sort on samples.
 * 
 * Sorts alignemnts by leftmost coordinates for downstream use. 
 * @see https://www.htslib.org/doc/samtools-sort.html
 * 
 * @input alignedSamples - Channel consisting of [ meta, [ alignedSamples ] ]
 * @emit sortedSamples - Channel consisting of [ meta, [ sortedSamples ] ]
 */

 process samtools_sort {
    
    label 'samtools'

    label 'def_cpu'
    label 'lil_mem'
    label 'lil_time'

    publishDir(
        path:    "${params.publishDirData}/sorted_samples/",
        mode:    "${params.publishMode}"
    )

    input:
        tuple val(meta), path(alignedSamples)

    output:
        tuple val(meta), path("*bam"), emit: sortedBams

    script:
        """
        samtools sort -m ${task.mem} \
        -@ ${task.cpus} \
        -o ${meta.uniqueID}.sorted.bam \
        ${alignedSamples}
        """
 }