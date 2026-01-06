/**
 * Process to run BWA-mem2 mem on samples.
 * 
 * Aligns samples to the user-specified reference genome and adds appropriate read groups.
 * @see https://github.com/bwa-mem2/bwa-mem2
 * 
 * @input filteredSamples - Channel consisting of [ meta, [ filteredForward, filteredReverse ] ]
 *        referenceFiles  - Channel consisting of [ [ reference, index1, index2, index3, index4, index5 ] ]
 * @emit  alignedSamples  - Channel consisting of [ meta, [ alignedSamples ] ]
 */

 process bwa_mem2_mem {
    
    label 'bwa-mem2'

    label 'big_cpu'
    label 'big_mem'
    label 'big_time'

    publishDir(
        path:    "${params.publishDirData}/aligned_samples/",
        mode:    'symlink'
    )

    input:
        tuple val(meta), path(filteredForward), path(filteredReverse)
        tuple path(reference), path(index1), path(index2), path(index3), path(index4), path(index5)

    output:
        tuple val(meta), path("*sam"), emit: alignedSamples

    script:
        """
        bwa-mem2 mem \
        -M -t ${task.cpus} \
        -R "@RG\tID:${meta.uniqueID}\tSM:${meta.sampleID}\tLB:${meta.libraryID}\tPL:${platformTechnology}" \
        ${reference} \
        ${filteredForward} ${filteredReverse} > ${meta.uniqueID}.aln.${reference.baseName}.sam
        """
 }