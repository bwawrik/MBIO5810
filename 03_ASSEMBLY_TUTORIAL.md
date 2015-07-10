### Basic Assembly Tutorial

1. Start a Droplet with at least 1GB of memory in Digital Ocean and ssh into it. Alternatively (and better), install and use [boot2docker](http://boot2docker.io/) on your local machine.  (See the previous tutorial about [creating and securing your own Digital Ocean droplet](./01_SSH_KEYS.md).)

1. Download the Docker [`bwawrik/bioinformatics:latest`](https://registry.hub.docker.com/u/bwawrik/bioinformatics/)

    ```
    docker pull bwawrik/bioinformatics:latest
    ```
    
1. Make a data directory

    ```sh
    mkdir /data
    ```

1. Start the docker and mount the `/data` directory. (See the previous tutorial about [Docker](02_PULLING_A_DOCKER_REPO.md)).

    ```sh
    docker run -t -i -v /data:/data bwawrik/bioinformatics:latest
    ```

1. Change your directory to `/data`

    ```sh 
    cd /data
    ```

1. Download the sample genome data set

    ```sh
    wget https://github.com/bwawrik/MBIO5810/raw/master/sequence_data/232_R1_40k.fastq.gz
    wget https://github.com/bwawrik/MBIO5810/raw/master/sequence_data/232_R2_40k.fastq.gz
    ```

1. unzip the data files

    ```sh
    gunzip *.gz
    ```

note: These two files represent forward and reverse reads of MySeq genome sequencing run. They are partial files to allow the assembly to complete in a reasonable amount of time. Together the files contain about 5*10^6 bp of sequence, which is about 1x coverage on the genome of SPR.


### Ray Assembly

*Brief [description](http://denovoassembler.sourceforge.net/index.html) of Ray:*

> Ray is a parallel software that computes de novo genome assemblies with next-generation sequencing data.  Ray is written in C++ and can run in parallel on numerous interconnected computers using the message-passing interface (MPI) standard.

1. Run a [Ray](http://denovoassembler.sourceforge.net/manual.html) assembly with a [k-mer](https://en.wikipedia.org/wiki/K-mer) setting of 31 as follows
  
    ```sh
    Ray -k31 -p 232_R1_40k.fastq 232_R2_40k.fastq -o ray_31/
    ```

1. If you wanted to do this with multiple cores do this (e.g. with six cores):
(This won't work yet. It requires [Open MPI](http://www.open-mpi.org/) to work on the Docker, which it does not yet do.)

    ```sh
    mpiexec -n 6 Ray -k31 -p output_forward_paired.fastq output_reverse_paired.fastq -o ray_31/
    ```

### Velvet Assembly

*Brief [description](https://www.ebi.ac.uk/~zerbino/velvet/) of Velvet:*

>Velvet is a de novo genomic assembler specially designed for short read sequencing technologies, such as Solexa or 454, developed by Daniel Zerbino and Ewan Birney at the European Bioinformatics Institute (EMBL-EBI), near Cambridge, in the United Kingdom.  Velvet currently takes in short read sequences, removes errors then produces high quality unique contigs. It then uses paired-end read and long read information, when available, to retrieve the repeated areas between contigs.

1. Let's try a [Velvet](https://www.ebi.ac.uk/~zerbino/velvet/) assembly.

    ```sh
    velveth velvet/ 31 -shortPaired -fastq -separate 232_R1_40k.fastq 232_R2_40k.fastq
    velvetg velvet/
    ```

1. Download the [N50](https://en.wikipedia.org/wiki/N50_statistic) perl script
 
    ```sh
    wget https://github.com/bwawrik/MBIO5810/raw/master/perl_scripts/N50.pl
    ```

1. Then assess the N50 stats on both assemblies.

    ```sh
    perl N50.pl velvet/contigs.fa
    perl N50.pl ray_31/Contigs.fasta
    ```

### Self-Examination
Which is faster ? Which is better ? Why ?
