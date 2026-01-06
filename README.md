# nf-dv-variant-calling
Nextflow pipeline to perform pre-processing of samples and variant calling.

## Preparing to Run the `nf-dv-variant-calling` pipeline
In order to run the pipeline, you must have the following inputs:
* Nextflow configured on your system (designed for SLURM-based schedulers)
* A reference genome for alignment steps
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

In the current iteration, the reverse file must be provided and cannot be optional. 

### Adjusting the `nextflow.config` file
Before running the pipeline, the `nextflow.config` file must be populated with the appropriate information. The user must define the following: projectTitle, samplesheet, reference, adapters
* `projectTitle`: A user-created project title for each individual run (ex: projectTitle = 'runOne_dissertation')
* `samplesheet`: A file path to the sample metadata in the form of a comma-delimited (.csv) file, containing the columns described above (ex: samplesheet = 'path/to/samplesheet.csv')
* `reference`: A file path to the FASTA file containing the appropriate reference genome ending in file extension `.fa`, and currently, requires that associated indexed files are located within the same directory (ex: reference = 'reference.fa')
* `adapters`: A file path to the FASTA file containing the appropriate adapter sequences to be removed, ending in file extension `.fa`. Please see [the Trimmomatic GitHub](https://github.com/usadellab/Trimmomatic/tree/main/adapters) for guidance on adapter file formatting or curated adapter files (ex: adapters = 'path/to/adapter/sequences/adapters.fa')


