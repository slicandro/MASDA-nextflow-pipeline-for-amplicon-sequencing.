#!/usr/bin/env nextflow

process kraken2_filter {

    tag "$sample_id"

    publishDir "results/cleaned_reads", pattern: "*.fastq.gz", mode: 'copy'
    publishDir "results/kraken_reports", pattern: "*.report", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)
    val(work_title)

    output:
    tuple val(sample_id), path("${sample_id}_cleaned.fastq.gz")

    script:
    """
    kraken2 \\
        --db /mnt/Disk07/slicandro/ACAJOACO/Secuenciacion_Paneles/my_kraken2_db \\
        --gzip-compressed \\
        --threads 4 \\
        --unclassified-out ${sample_id}_cleaned.fastq \\
        --report ${sample_id}.report \\
        $reads

    gzip -f ${sample_id}_cleaned.fastq
    """
}