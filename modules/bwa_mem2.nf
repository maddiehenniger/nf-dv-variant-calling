/**
 * Process to run BWA-mem2 on samples.
 * 
 * Aligns samples to the user-specified reference genome and adds appropriate read groups.
 * @see https://github.com/bwa-mem2/bwa-mem2
 * 
 * @input -
 * @emit -
 */

 process bwa_mem2 {
    
    label 'bwa'

    label 'def_cpu'
    label 'lil_mem'
    label 'lil_time'

    publishDir(
        path:    "${params.publishDirData}/aligned_samples/",
        mode:    "${params.publishMode}"
    )

    input:
        tuple val(meta), path(filteredForward), path(filteredReverse)
        path(reference)

    output:
        tuple val(meta), path("*sam"), emit: alignedSamples

    script:
        """
        bwa-mem2 mem \
        -M -t 80 \
        -R '@RG\tID:${meta.uniqueID}.${meta.laneID}\tSM:${meta.sampleID}\tLB:${meta.libraryID}\tPL:${platformTechnology}' \
        ${reference} \
        ${filteredForward} ${filteredReverse} > ${meta.uniqueID}.${meta.laneID}.aln.ARS-UCD1.2_Btau5.0.1Y.sam
        """
 }