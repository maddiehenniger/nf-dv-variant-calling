/**
 * Process to run FASTQC on samples.
 * 
 * Generates summary statistics on a per-sample basis.
 * @see https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/
 * 
 * @input -
 * @emit -
 */

 process fastqc_stats {
    
    label 'fastqc'

    label 'def_cpu'
    label 'lil_mem'
    label 'lil_time'

    publishDir(
        path:    "${params.publishDirData}/raw_statistics/",
        mode:    "${params.publishMode}"
    )

    input:
        tuple val(meta), path(forwardPath), path(reversePath)

    output:
        tuple path("*.zip"), path("*.html")

    script:
        """
        fastqc -t 8 ${forwardPath} ${reversePath}
        """
 }