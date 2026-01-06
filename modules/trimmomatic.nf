/**
 * Process to run Trimmomatic on samples.
 * 
 * Performs adapter trimming and quality filtering on input samples.
 * @see https://github.com/usadellab/Trimmomatic
 * 
 * @input -
 * @emit -
 */

 process fastqc_stats {
    
    label 'trimmomatic'

    label 'def_cpu'
    label 'lil_mem'
    label 'lil_time'

    publishDir(
        path:    "${params.publishDirData}/filtered_files/",
        mode:    "${params.publishMode}"
    )

    input:
        tuple val(meta), path(forwardPath), path(reversePath)

    output:
        tuple val(meta), path("${meta.uniqueID}.1.P.fq"), path("${meta.uniqueID}.2.P.fq"), emit: trimmed

    script:
        """
        apptainer exec ../../../trimmomatic_0-40.sif java -Xmx4g -jar /usr/local/share/trimmomatic-0.40-0/trimmomatic.jar \
        PE -phred33 \
        -threads 24 \
        -summary ${meta.uniqueID}.TRIM.SUMMARY \
        ${forwardPath} ${reversePath} \
        ${meta.uniqueID}.1.P.fq ${meta.uniqueID}.1.U.fq \
        ${meta.uniqueID}.2.P.fq ${meta.uniqueID}.2.U.fq \
        MINLEN:35 TOPHRED33 ILLUMINACLIP:${params.adapters}:2:30:6:1:TRUE \
        LEADING:20 TRAILING:20 SLIDINGWINDOW:3:15 AVGQUAL:20 MINLEN:35
        """
 }