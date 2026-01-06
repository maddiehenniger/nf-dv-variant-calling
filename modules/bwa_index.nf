/**
 * Process to run bwa index on samples.
 * 
 * Indexes the reference genome to prepare for sample alignment.
 * @see https://bio-bwa.sourceforge.net/bwa.shtml
 * 
 * @input reference - File path to the reference genome and associated indexed files 
 * @emit  referenceFiles - Channel consisting of [ [ reference, index1, index2, index3, index4, index5 ] ]
 */

 process bwa_index {
    
    label 'bwa'

    label 'big_cpu'
    label 'big_mem'
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
        bwa index \
        ${reference}
        """
 }