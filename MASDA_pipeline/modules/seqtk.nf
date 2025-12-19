#!/usr/bin/env nextflow

process seqtk_fastq_filter {

    tag "$sample_id"

    publishDir "results/seqtk_fastq", pattern: "*.fastq.gz", mode: 'copy'

    input:
    tuple val(sample_id), path(fasta), path(original_fastq)
    val(work_title)

    output:
    tuple val(sample_id), path("${sample_id}_filtered.fastq.gz")

    script:
    """
    # Convert FASTA to list of IDs
    grep '^>' $fasta | sed 's/^>//' > ${sample_id}_ids.txt

    # Extract those reads from the original FASTQ using seqtk
    seqtk subseq $original_fastq ${sample_id}_ids.txt | gzip > ${sample_id}_filtered.fastq.gz
    """
}