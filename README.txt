MASDA pipe

Massive Amplicon Sequencing Data Analysis pipeline

MASDA pipe is a Nextflow-based pipeline developed for the analysis of amplicon sequencing data generated using AmpliSeq / AgriSeq panels on Ion Torrent platforms. While optimized for these technologies, the pipeline can be adapted for other amplicon sequencing panels.

The pipeline processes each sample independently, performing quality control, filtering, alignment, and read quantification to determine presence/absence of panel targets.

Pipeline overview

For each sample, MASDA pipe performs the following steps:

1. Read preprocessing

Adapter trimming and quality filtering using fastp

Chimera detection and removal using vsearch

2. Background / host DNA removal

Taxonomic classification and filtering using kraken2

3. Target detection by alignment

Strict Bowtie2 alignment (end-to-end, 100% identity) against the primer panel design reference to detect target presence/absence

Relaxed Bowtie2 alignment (still end-to-end) against the designed amplicon sequences, extracted from:

The panel .bed file

The multifasta reference used for primer design

4. Read quantification

Read counting using featureCounts

Generation of per-sample count tables for both alignment strategies

Downstream analysis

Downstream data analysis is not currently integrated into the pipeline.
At present, this step is performed using a Jupyter Notebook, which is included in this repository.

The downstream analysis depends on the primer panel design. In its current implementation, MASDA pipe is used to derive presence/absence information for the targeted amplicons.

Requirements

Linux operating system

Conda / Miniconda

Nextflow

Sufficient storage and memory for reference indices and intermediate files

Installation and usage
1. Clone the repository
git clone <repository_url>
cd MASDA_pipe

2. Create the Conda environment

Create the Conda environment using the YAML file located in the environment/ directory:

conda env create -f environment/MASDA_pipe.yaml


⚠️ Important: All tools used by the pipeline are executed from this environment.

2.2 (Optional) AmpliSeq panel preparation

If you are using an AmpliSeq primer panel, download the panel files and extract the designed amplicon sequences from the provided .bed file.

3. Generate GFF annotation files

Using the scripts located in the scripts/ directory, generate a .gff file for each reference used by the pipeline:

Primer design multifasta reference

Designed amplicon multifasta reference

4. Build Bowtie2 indices

Using Bowtie2 from the Conda environment, build indices for both references:

bowtie2-build primer_design.fasta primer_design
bowtie2-build amplicons.fasta amplicons

5. Install Nextflow

Install Nextflow by following the official documentation:

https://www.nextflow.io/docs/latest/getstarted.html

5.2 (Optional)

Modify MASDA_main.nf to update default input and reference paths if necessary.

6. Configure the pipeline environment

Edit the Nextflow configuration file and set the absolute path to the Conda environment:

params.env_path = "/absolute/path/to/MASDA_pipe_env"

7. Run the pipeline

To verify that the pipeline is correctly configured, run:

nextflow run MASDA_main.nf --help


If this command executes successfully, the pipeline is correctly installed and ready to run.

Notes

Step 2 (Conda environment creation) is mandatory for correct execution.

All tools are executed via Conda; container-based execution (Docker/Singularity) may be added in future versions.

License

[Add license information here]

Contact

[Add contact or maintainer information here]
