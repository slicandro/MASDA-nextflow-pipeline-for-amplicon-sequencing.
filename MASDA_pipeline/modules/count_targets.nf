#!/usr/bin/env nextflow

/*
 *  Count reads mapped to target regions using featureCounts. Target regions in this case are the amplicons retrieved from the panel design.
 */
process count_targets {

    tag "$sample_id"

    publishDir "results/amplicon_counts", pattern: "targets*featureCounts.txt", mode: 'copy'

    input:
    tuple val(sample_id), path(bamfiles)
    path(targets_gtf)
    val(work_title)

    output:
    tuple val(sample_id), path("targets_${sample_id}_${work_title}_featureCounts.txt")

    script:
    """
    # Run featureCounts on the BAM file
    featureCounts -t contig -a ${targets_gtf} -o targets_${sample_id}_${work_title}_featureCounts.txt $bamfiles

    """
}