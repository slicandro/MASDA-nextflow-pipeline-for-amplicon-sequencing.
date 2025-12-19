#!/usr/bin/env nextflow

/*
 * Trimm adapters and filter reads using fastp
 */
process trim_adapters {
    tag "$sample_id"

    publishDir "results/trimmed_reads", mode: 'copy'
    input:
    tuple val(sample_id), path(raw_reads)
    val(work_title)
    
    output:
    tuple val(sample_id), path("${sample_id}_${work_title}_trimmed.fastq.gz")

    script:
    
    """
    fastp \
        -i ${raw_reads} \
        -o ${sample_id}_${work_title}_trimmed.fastq.gz \
        --detect_adapter_for_pe \
        --thread 8 \
        --max_len1 400 \
        --qualified_quality_phred 20 \
        --length_required 50
    """
}