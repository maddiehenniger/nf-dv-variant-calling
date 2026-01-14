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
    label 'med_time'

    publishDir(
        path:    "${params.publishDirData}/sorted_samples/",
        mode:    "symlink"
    )

    input:
        tuple val(meta), path(alignedSamples)

    output:
        tuple val(meta), path("*bam"), emit: sortedBams

    script:
        """
        samtools sort \
        -@ ${task.cpus} \
        -o ${meta.uniqueID}.sorted.bam \
        -T ${alignedSamples.baseName}.TMP \
        ${alignedSamples}
        """
 }