### Basic Assembly Tutorial

- Start a droplet with at least 1GB of memory in Digital Ocean and ssh into it. Alternatively (and better) install and use boot2docker on your local machine.
- Download the docker bwawrik/bioinformatics:latest

docker pull bwawrik/bioinformatics:latest

Make a data directory

mkdir /data

Start the docker and mount /data

docker run -t -i -v /data:/data bwawrik/bioinformatics:latest

Change your directory to /data

cd /data

Download the sample genome data set

wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/232_R1_40k.fastq
wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/232_R2_40k.fastq

*note: These two files represent forward and reverse reads of MySeq genome sequencing run. They are partial files to allow the assembly to complete in a reasonable amount of time. Together the files contain about 5*10^6 bp of sequence, which is about 1x coverage on the genome of SPR.

Run a Ray assembly with a k-mer setting of 31 as follows

Ray -k31 -p 232_R1_40k.fastq 232_R2_40k.fastq -o ray_31/

If you wanted to do this with multiple cores do this (e.g. with six cores):
(This won't work yet. It requires openMPI to work on the docker, which it does not yet do)

mpiexec -n 6 Ray -k31 -p output_forward_paired.fastq output_reverse_paired.fastq -o ray_31/

Lets try a velvet assembly.

velveth velvet/ 31 -shortPaired -fastq -separate 232_R1_40k.fastq 232_R2_40k.fastq
velvetg velvet/

Create the N50.pl file by starting nano and pasting the script in from the evernote. Then assess the N50 stats on both assemblies.

perl N50.pl velvet/contigs.fa
perl N50.pl ray_31/Contigs.fasta

Which is faster ? Which is better ? Why ?
