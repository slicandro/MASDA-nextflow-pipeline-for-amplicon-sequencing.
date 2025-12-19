#!/usr/bin/env nextflow

/*
 * Filter quality and chimera removal via vsearch
 */
process filter_quality {
    label 'long'
    
    conda 'bioconda::vsearch=2.21.1'

    publishDir "results/filtered", mode: 'copy'

    tag "$sample_id"

    input:
    tuple val(sample_id), path(reads)
    val(work_title)

    output:
    tuple val(sample_id), path("filtered_${sample_id}_${work_title}_no_chimeras.fasta"), path("filtered_${sample_id}_${work_title}.fastq.gz")

    script:
    """
    vsearch --fastq_filter ${reads} \
            --fastq_maxee 1.0 \
            --fastq_minlen 75 \
            --fastq_qmax 45 \
            --fastqout filtered_${sample_id}_${work_title}.fastq.gz
    
    vsearch --uchime_denovo filtered_${sample_id}_${work_title}.fastq.gz \
            --nonchimeras filtered_${sample_id}_${work_title}_no_chimeras.fasta \
            --chimeras chimeric_${sample_id}_${work_title}.fasta \
    """
}