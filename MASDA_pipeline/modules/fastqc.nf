#!/usr/bin/env nextflow

process perform_fastqc {

    tag "$sample_id"

    publishDir "results/fastqc", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)
    val(work_title)

    output:
    tuple val(sample_id)

    script:
    """
    fastqc \\
        --outdir . \\
        --threads 4 \\
        $reads
    """
}