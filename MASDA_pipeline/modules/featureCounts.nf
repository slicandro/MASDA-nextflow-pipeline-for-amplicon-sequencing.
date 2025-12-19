#!/usr/bin/env nextflow

/*
 *  Count reads mapped to target regions using featureCounts. Target regions in this case are genes used for panel design.
 */
process feature_counts {

    tag "$sample_id"

    publishDir "results/feature_counts", pattern: "*featureCounts.txt", mode: 'copy'

    input:
    tuple val(sample_id), path(bamfiles)
    path(db_gtf)
    val(work_title)

    output:
    tuple val(sample_id), path("${sample_id}_${work_title}_featureCounts.txt")

    script:
    """
    # Run featureCounts on the BAM file
    featureCounts -t contig -a ${db_gtf} -o ${sample_id}_${work_title}_featureCounts.txt $bamfiles

    """
}