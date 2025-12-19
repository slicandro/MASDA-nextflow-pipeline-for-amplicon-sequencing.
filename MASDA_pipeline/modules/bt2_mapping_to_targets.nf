#!/usr/bin/env nextflow

/*
 * Non-strict mapping of cleaned reads to target regions using bowtie2. In this case, the reference would be a multifasta reconstructed from the .bed coordinates and the multifasta used as reference for the panel desing. 
 */
process bowtie_map2paneltargets {

    tag "$sample_id"

    publishDir "results/amplicon_alignments", pattern: "*.bam", mode: 'copy'

    input:
    tuple val(sample_id), path(cleaned_fastq)
    val(targets_db)
    val(work_title)

    output:
    tuple val(sample_id), path("amplicon_${sample_id}_${work_title}_sorted.bam")

    script:
    """
    bowtie2 -x $targets_db -U $cleaned_fastq \\
            -S targets_${sample_id}_${work_title}.sam \\
            --very-sensitive \\
            --end-to-end \\
    
    samtools view -bS targets_${sample_id}_${work_title}.sam | samtools sort -o amplicon_${sample_id}_${work_title}_sorted.bam
    samtools index amplicon_${sample_id}_${work_title}_sorted.bam
    rm targets_${sample_id}_${work_title}.sam
    echo "Amplicon mapping finished for $sample_id"
    """
}