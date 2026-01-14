# nf-dv-variant-calling
Nextflow pipeline to perform pre-processing of samples and variant calling.

## Preparing to Run the `nf-dv-variant-calling` pipeline

In order to run the pipeline, you must have the following inputs:
* Nextflow configured on your system (designed for SLURM-based schedulers)
* A reference genome for alignment steps (recommended: Pre-indexed BWA-mem2 index files)
* Input sample(s) that require quality filtering and adapter trimming, alignment to a reference genome, and sorting/merging/marking duplicates. 
* Sample metadata for downstream processes

### Sample metadata
The sample metadata sheet must be formatted as a CSV file containing the following columns: uniqueID, sampleID, laneID, libraryID, platformTechnology, flowCellPixelDistance, forwardPath, and reversePath
* `uniqueID`: A user-specified unique ID must be defined for each sample. It is critical that this ID is actually unique, even if samples were sequenced across multiple lanes (ex: SAMPLE_1.L001, SAMPLE_1.L002, SAMPLE_2.L001, SAMPLE_3.L001, SAMPLE_3.L002...)
* `sampleID`: An associated sample ID must be defined for each sample. This value does not need to be unique, and should link samples together even if sequenced across multiple lanes (ex: SAMPLE_1, SAMPLE_2, SAMPLE_3)
* `laneID`: The lane ID associated with each sample should be provided. (ex: Lane001, L001...)
* `libraryID`: The associated DNA preparation library ID should be provided. This is not if the sample has been sequenced across multiple lanes, but rather to detect molecular duplicates. See the [GATK dictionary](https://gatk.broadinstitute.org/hc/en-us/articles/360035890671-Read-groups) to understand the usage of the libraryID column - under `LB` = DNA preparation library identifier
* `platformTechnology`: The sequencing platform technology must be provided by the user, and can only be the values: ILLUMINA, SOLID, LS454, HELICOS, or PACBIO as confined by read group fields required by GATK
* `flowCellPixelDistance`: A numeric value representing the appropriate optical pixel distance for either traditional flow cells (100) or patterned flow cells (2500), which is based on the source of the data
* `forwardPath`: A FASTQ(.gz) file path must be provided to the forward reads of the associated sample, and must end in .fastq or .fastq.gz
* `reversePath`: A FASTQ(.gz) file path must be provided to the reverse reads of the associated sample, and must end in .fastq or .fastq.gz

In the current version of the workflow, the reverse file must be provided and cannot be optional. 

### Adjusting the `nextflow.config` file
Before running the pipeline, the `nextflow.config` file must be populated with the appropriate information. The user must define the following: projectTitle, samplesheet, reference, adapters
* `projectTitle`: A user-created project title for each individual run (ex: projectTitle = 'runOne_dissertation')
* `samplesheet`: A file path to the sample metadata in the form of a comma-delimited (.csv) file, containing the columns described above (ex: samplesheet = 'path/to/samplesheet.csv')
* `reference`: A file path to the FASTA file containing the appropriate reference genome ending in file extension `.fa` (ex: reference = 'reference.fa')
* `adapters`: A file path to the FASTA file containing the appropriate adapter sequences to be removed, ending in file extension `.fa`. Please see [the Trimmomatic GitHub](https://github.com/usadellab/Trimmomatic/tree/main/adapters) for guidance on adapter file formatting or curated adapter files (ex: adapters = 'path/to/adapter/sequences/adapters.fa')

Please note that, although the pipeline will detect if BWA-mem2-formatted index files for the reference genome are not located within the same directory as the provided reference to perform indexing, it is recommended to provide them within the same directory. The BWA-mem2 index files end in extensions `{reference}.0123`, `{reference}.amb`, `{reference}.ann`, `{reference}.bwt.2bit.64`, and `{reference}.pac` and assume the same prefix as the reference (ex: for a reference file named ARS-UCD1.2.fa, the indexed files would be: ARS-UCD1.2.fa.0123, ARS-UCD1.2.fa.amb, ARS-UCD1.2.fa.ann, and so on...). Please refer to the BWA-mem2 indexing documentation for further questions or details.

## Pipeline overview

The pipeline currently performs the general overall steps:
* Indexes and prepares the reference genome
* Adapter trims and quality filters input samples
* Aligns filtered samples to the reference genome
* Performs alignment post-processing (sorting, merging, and marking duplicates)

### Reading in the samples and reference genome


### Adapter trimming and quality filtering
Low-quality bases and adapters are removed using Trimmomatic v0.40 (Bolger et al., 2014) [GitHub for Trimmomatic](https://github.com/usadellab/Trimmomatic).

## Citations

If you use this pipeline in your work, consider citing the following tools that make it possible:

| BWA-mem2: Vasimuddin Md, Sanchit Misra, Heng Li, Srinivas Aluru. Efficient Architecture-Aware Acceleration of BWA-MEM for Multicore Systems. IEEE Parallel and Distributed Processing Symposium (IPDPS), 2019. 10.1109/IPDPS.2019.00041

| Appropriate Samtools papers: https://www.htslib.org/doc/#publications

| Nextflow: P. Di Tommaso, et al. Nextflow enables reproducible computational workflows. Nature Biotechnology 35, 316–319 (2017) doi:10.1038/nbt.3820

| Appropriate GATK publications (Picard): https://gatk.broadinstitute.org/hc/en-us/articles/360035530852-How-should-I-cite-GATK-in-my-own-publications

| Trimmomatic: Anthony M. Bolger, Marc Lohse, Bjoern Usadel, Trimmomatic: a flexible trimmer for Illumina sequence data, Bioinformatics, Volume 30, Issue 15, August 2014, Pages 2114–2120, https://doi.org/10.1093/bioinformatics/btu170

