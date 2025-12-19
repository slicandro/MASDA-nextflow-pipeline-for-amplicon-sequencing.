The Masive Amplicon Sequencing Data Analyisis pipeline (MASDA pipe) is a nextflow written pipeline created for AmpliSeq / AgriSeq users but possibly good to use with other amplicon sequencing panels for IonTorrent. 
It treats each sample individually and performs fastp, vsearch (for chimera removal), kraken2 (for host or background DNA derived reads removal). 
Once the reads have been "cleaned" and processed, the pipeline performs a bowtie2 (100% homology end to end) alignment of the sequences to the primer panel design reference in order to detect the presence absence of the targets.
Another bowtie2 alignment (less strict, still end-to-end) is performed to the panel designed amplicons (extracted from .bed file coordinates and the multifasta used as reference for the primer panel desing). 
Later, the pipeline uses FeatureCounts to count the obtained reads for each alignment and outputs both tables for each sample used for the study. 
Downstream data analysis is still not incorporated to this pipeline as its currently a jupiter notebook (included in this repository). 
Depending on the primer panel the type of analysis to perform, in my case my primer panel outputs presence-absence information.

How to run:

1 - Clone this repository to your working directory using git clone and the URL of this repository.
2 - Using conda create the MASDA_pipe environment from the .yaml file contained in the environment directory.
2.2 (OPTIONAL) - If the user is using a AmpliSeq primer panel, they will have to download the panel files and extract the amplicon sequences from the .bed file.
3 - With the scripts contained in the scripts directory, the user must generate the .gff file for each reference it will use for the alignments (both desing multifasta and amplicon desgined multifasta).
4 - With the bowtie2 from the environment, the user must build the two references (primer design multifasta and extracted amplicons multifasta) using the bowtie2-build command.
5 - Install nextflow.
5.2 (OPTIONAL) Modify MASDA_main.nf default paths to match your files.
6 - run the pipeline in the cmd with the following command:
    $ nextflow run MASDA_main.nf --help
                                                                                                        
If that works it means the pipeline should work correctly. All the programs will be ran from the environment so the step 2 is crucial.
