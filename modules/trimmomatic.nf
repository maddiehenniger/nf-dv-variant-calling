/**
 * Process to run Trimmomatic on samples.
 * 
 * Performs adapter trimming and quality filtering on input samples.
 * @see https://github.com/usadellab/Trimmomatic
 * 
 * @input samples  - Channel consisting of [ meta, [ forwardPath, reversePath ] ]
 *        adapters - File path to a FASTA file containing adapter sequences to be removed
 * @emit trimmed - Channel consisting of [ meta, [ trimmedForward, trimmedReverse ] ]
 */

 process run_trimmomatic {
    
    label 'trimmomatic'

    label 'med_cpu'
    label 'med_mem'
    label 'med_time'

    publishDir(
        path:    "${params.publishDirData}/filtered_files/",
        mode:    'symlink'
    )

    input:
        tuple val(meta), path(forwardPath), path(reversePath)
        path(adapters)

    output:
        tuple val(meta), path("${meta.uniqueID}.1.P.fq"), path("${meta.uniqueID}.2.P.fq"), emit: trimmed
        path("*.TRIM.SUMMARY"), emit: trimmedStats
        path("*.U.fq"), emit: unpairedReads

    script:
        """
        export _JAVA_OPTIONS="-Xmx4g"

        trimmomatic PE -phred33 -threads ${task.cpus} \
        -summary ${meta.uniqueID}.TRIM.SUMMARY \
        ${forwardPath} ${reversePath} \
        ${meta.uniqueID}.1.P.fq ${meta.uniqueID}.1.U.fq \
        ${meta.uniqueID}.2.P.fq ${meta.uniqueID}.2.U.fq \
        MINLEN:35 TOPHRED33 ILLUMINACLIP:${adapters}:2:30:6:1:TRUE \
        LEADING:20 TRAILING:20 SLIDINGWINDOW:3:15 AVGQUAL:20 MINLEN:35
        """
 }