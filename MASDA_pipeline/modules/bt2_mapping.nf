#!/usr/bin/env nextflow

/*
 *  Strict mapping of cleaned_reads to custom reference using bowtie2. In this case, the reference is the one given to the ampliseq designer to create the panel.
 */

process bowtie_mapping {

    tag "$sample_id"

    publishDir "results/strict_alignments", pattern: "*.bam", mode: 'copy'

    input:
    tuple val(sample_id), path(cleaned_fastq) 
    val(mapping_db)
    val(work_title)
    
    output:
    tuple val(sample_id), path("strict_${sample_id}_${work_title}_sorted.bam")

    script:
    """
    bowtie2 -x $mapping_db -U $cleaned_fastq -S ${sample_id}_${work_title}.sam \\
        --very-sensitive \\
        --score-min "L,0,0" \\
        --mp 100,100 \\
        --np 100 \\
        --rdg 100,100 \\
        --rfg 100,100 \\
        --end-to-end 

    samtools view -bS ${sample_id}_${work_title}.sam | samtools sort -o strict_${sample_id}_${work_title}_sorted.bam
    samtools index strict_${sample_id}_${work_title}_sorted.bam
    rm ${sample_id}_${work_title}.sam
    echo "Strict mapping completed for sample $sample_id"
    """
}