/**
 * Process to run BWA-mem2 index on samples.
 * 
 * Indexes the reference genome to prepare for sample alignment.
 * @see https://github.com/bwa-mem2/bwa-mem2
 * 
 * @input reference - File path to the reference genome and associated indexed files 
 * @emit  referenceFiles - Channel consisting of [ [ reference, index1, index2, index3, index4, index5 ] ]
 */

 process bwa_mem2_index {
    
    label 'bwa'

    label 'med_cpu'
    label 'med_mem'
    label 'def_time'

    publishDir(
        path:    "${params.publishDirData}/reference_files/",
        mode:    'symlink'
    )

    input:
        path reference

    output:
        tuple path(reference), path("*.0123"), path("*.amb"), path("*.ann"), path("*.2bit.64"), path("*.pac"), emit: referenceFiles

    script:
        """
        bwa-mem2 index \
        ${reference}
        """
 }