### Basic Assembly Tutorial

1. Start a droplet with at least 1GB of memory in Digital Ocean and ssh into it. Alternatively (and better) install and use boot2docker on your local machine.  (See the previous tutorial about [creating and securing your own Digital Ocean droplet](./01_SSH_KEYS.md).)

1. Download the docker bwawrik/bioinformatics:latest

    ```sh
    docker pull bwawrik/bioinformatics:latest
    ```
    
1. Make a data directory

    ```sh
    mkdir /data
    ```

1. Start the docker and mount /data. (See the previous tutorial about [Docker](02_PULLING_A_DOCKER_REPO.md)).

    ```sh
    docker run -t -i -v /data:/data bwawrik/bioinformatics:latest
    ```

1. Change your directory to /data

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

1. Run a Ray assembly with a k-mer setting of 31 as follows
  
    ```sh
    Ray -k31 -p 232_R1_40k.fastq 232_R2_40k.fastq -o ray_31/
    ```

1. If you wanted to do this with multiple cores do this (e.g. with six cores):
(This won't work yet. It requires openMPI to work on the docker, which it does not yet do)

    ```sh
    mpiexec -n 6 Ray -k31 -p output_forward_paired.fastq output_reverse_paired.fastq -o ray_31/
    ```

### Velvet Assembly

1. Let's try a velvet assembly.

    ```sh
    velveth velvet/ 31 -shortPaired -fastq -separate 232_R1_40k.fastq 232_R2_40k.fastq
    velvetg velvet/
    ```

1. Download the N50 perl script
 
    ```sh
    wget https://github.com/bwawrik/MBIO5810/raw/master/perl_scripts/N50.pl
    ```

1. Then assess the N50 stats on both assemblies.

    ```sh
    perl N50.pl velvet/contigs.fa
    perl N50.pl ray_31/Contigs.fasta
    ```

#### Which is faster ? Which is better ? Why ?
