#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// We include all modules.

include { trim_adapters } from './modules/fastp.nf'
include { filter_quality } from './modules/filter_quality.nf'
include { kraken2_filter } from './modules/kraken2.nf'
include { perform_fastqc } from './modules/fastqc.nf'
include { bowtie_mapping } from './modules/bt2_mapping.nf'
include { bowtie_map2paneltargets } from './modules/bt2_mapping_to_targets.nf'
include { feature_counts } from './modules/featureCounts.nf'
include { count_targets } from './modules/count_targets.nf'
include { seqtk_fastq_filter } from './modules/seqtk.nf'

params.reads = "/mnt/Disk07/slicandro/ACAJOACO/Secuenciacion_Paneles/MASDA_pipeline/data/*.fastq.gz"
params.mapping_db = "/mnt/Disk07/slicandro/ACAJOACO/Secuenciacion_Paneles/MASDA_pipeline/indexes/bowtie2_ResFinder_AMR_index/bowtie2_ResFinder_AMR_index"
params.targets_db = "/mnt/Disk07/slicandro/ACAJOACO/Secuenciacion_Paneles/MASDA_pipeline/indexes/bowtie2_AMR_amplicon_index/bowtie2_AMR_amplicon_index"
params.db_gtf = "/mnt/Disk07/slicandro/ACAJOACO/Secuenciacion_Paneles/MASDA_pipeline/references/referencia_resfinder_AMR.gtf"
params.targets_gtf = "/mnt/Disk07/slicandro/ACAJOACO/Secuenciacion_Paneles/MASDA_pipeline/references/referencia_targets_AMRpanel.gtf"
params.work_title = "AMR_ResFinder"
params.help = false

workflow {

    if (params.help) {
    log.info """
    Usage:
        nextflow run main.nf [options] ...

    Options:
        --reads <file/files>        Path to input read file or files
        --mapping_db <path>        Path to the Bowtie2 mapping database
        --targets_db <path>       Path to the targets database
        --db_gtf <path>            Path to the GTF file for featureCounts
        --targets_gtf <path>      Path to the GTF file for targets
        --work_title <title>       Title for the work (default: AMR_ResFinder), this will be used to name the output files.
        --help                 Show this help message

    Example:
        nextflow run main.nf --reads path_to_my_fastq_file.fastq --mapping_db path_to_database/ --db_gtf path_to_gtf_file/ --work_title My_Work_Title
    """
    exit 0
}

    def n_files = 0
    def pattern = params.reads.replaceAll('^.*/', '').replaceAll('\\*', '.*')
    def dir = params.reads.contains('/') ? params.reads.substring(0, params.reads.lastIndexOf('/')) : '.'
    def d = new File(dir)
    if (d.exists()) {
        n_files = d.listFiles().findAll { it.name ==~ ~"${pattern}" }.size()
    }

    // Log to warn the user about the parameters being used for this pipline run.
    log.info "Starting pipeline with work title: ${params.work_title}"
    log.info "Using reads from: ${params.reads}"
    ifEmpty { n_files == 0 } {
        log.error "No files found for the given reads pattern: ${params.reads}. Please check the path and pattern."
        exit 1
    }
    log.info "If you want to change the reads, please edit the params.reads variable in the main.nf file or run the pipeline with the --reads option. \n \t Use the wildcard * to select multiple files. Example path_to_files_directory/*.fastq.gz"
    log.info "This workflow will map the reads to the ${params.mapping_db} database. \n \t If you want to change it, please edit the params.mapping_db variable in the main.nf file or run the pipeline with the --mapping_db option."
    log.info "This workflow will use the GTF file for featureCounts: ${params.db_gtf}. \n \t If you want to change this, please edit the params.db_gtf variable in the main.nf file or run the pipeline with the --db_gtf option."
    log.info "This workflow will use the targets GTF file: ${params.targets_gtf}. \n \t If you want to change this, please edit the params.targets_gtf variable"
    log.info "This workflow will map the reads to the ${params.targets_db} database. \n \t If you want to change it, please edit the params.targets_db variable in the main.nf file or run the pipeline with the --targets_db option."

    // Log the number of files found in the input directory.
    log.info "Input reads channel created with ${n_files} files."

    //Here we define an input channel that will contain the read files to be processed.
    reads_ch = Channel.fromPath(params.reads, glob: true)
                       .map { file -> 
                            def name = file.baseName.replaceAll(/\.fastq$/, '')
                            tuple(name, file)
                       }

    //We create quality control and processing steps for the reads.
    //Running multiqc could be optimal here if you have multiple samples.
    fastqc = perform_fastqc(reads_ch, params.work_title)

    //On paralel the reads are processed to trim adapters, filter by quality, and clean with kraken2.
    //We can use the fastqc results to filter the reads, but for now we will just process them with default parameters.
    trimmed = trim_adapters(reads_ch, params.work_title)
    filtered = filter_quality(trimmed, params.work_title)
    filtered_fastqs = seqtk_fastq_filter(filtered, params.work_title)
    cleaned = kraken2_filter(filtered_fastqs, params.work_title)

    //Mapeamos los reads a una referencia con Bowtie2
    aligned = bowtie_mapping(cleaned, params.mapping_db, params.work_title)
    targets = bowtie_map2paneltargets(cleaned, params.targets_db, params.work_title)
    counts = feature_counts(aligned, params.db_gtf, params.work_title)
    counts_targets = count_targets(targets, params.targets_gtf, params.work_title)

}