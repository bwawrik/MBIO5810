#### Determining the Completeness of Draft Genome

Genome sequencing has become very routine. Unfortunately, very few projects these days try to complete microbial genomes. Instead, sequencing is typically conducted via a next-gen approach and genomes are assembled, discarding all contigs shorter than a minimum length.  In most cases, assuming that a genome is sequenced to a coverage of about 200x, this leads to 50-100 contigs of varying length, but circles are rarely complete.  Similarly, metagenomics approaches allow binning of genomes based on, for example, tetranucleotide frequencies and the phylogenetic affiliation of housekeeping genes, but this only results in partial genome bins.  In these cases, it helps to be able to assess how complete ones assembly is, i.e. what proportion of a bacterial genome is not captured by the assembly. This tutorial show how to make this estimate by determining the presence of single copy marker genes as discussed by Wu et al. :

```
Wu, D.Y., Jospin, G., and Eisen, J.A. (2013) Systematic Identification of Gene Families for Use as "Markers" for Phylogenetic and Phylogeny-Driven Ecological Studies of Bacteria and Archaea and Their Major Subgroups. Plos One 8.
```

##### Getting Started

- Download the docker bwawrik/bioinformatics:latest

```sh
docker pull bwawrik/biorinformatics:latest
```

- Make a data directory. If you are working locally on a mac using boot2docker you will need to work in ~/data. Please replace where appropriate

```sh
mkdir /data
(* on  your mac: mkdir ~/data)
```

- Start the docker and mount /data

```sh
docker run -t -i -v /data:/data bwawrik/bioinformatics:latest
(* locally on mac: docker run -t -i -v ~/data:/data bwawrik/bioinformatics:latest)
```

- Download the data files.  

```sh
https://github.com/bwawrik/MBIO5810/raw/master/sequence_data/SDB_ONE.faa
https://github.com/bwawrik/MBIO5810/raw/master/sequence_data/F21.faa.gz
gunzip F21.faa.gz
```

I'm giving you two fasta files here of predicted amino acid sequences.  These are derived from genome bins, one from a metagenome (SDB_ONE.faa), the other from single cell genomcis experiments (.


DO THE HMM SEARCH


```sh 
hmmsearch -E 0.0000000001 --domtblout SDB_one_sscmarkers.domtblout.txt /data/DATABASES/SINGLE_COPY_GENE_HMMs/sc_markers_bacteria.hmm SDB_ONE.faa > SDB_one_sscmarkers.hmmsearch.txt
```

FIND ALL THE HITS

awk '{print $4}' SDB_one_sscmarkers.domtblout.txt 

UNIQUE HITS

awk '{print $4}' SDB_one_sscmarkers.domtblout.txt | sort -u

COUNT THEM

awk '{print $4}' SDB_one_sscmarkers.domtblout.txt | sort -u | wc -l



hmmsearch -E 0.00001 --domtblout SDB_one_sscmarkers.domtblout.txt /data/DATABASES/SINGLE_COPY_GENE_HMMs/sc_markers_bacteria.hmm SDB_ONE.faa > SDB_one_sscmarkers.hmmsearch.txt
hmmsearch -E 0.00001 --domtblout SCADC_sscmarkers.domtblout.txt /data/DATABASES/SINGLE_COPY_GENE_HMMs/sc_markers_bacteria.hmm SCADC.faa > SDB_one_sscmarkers.hmmsearch.txt
hmmsearch -E 0.00001 --domtblout D17_sscmarkers.domtblout.txt /data/DATABASES/SINGLE_COPY_GENE_HMMs/sc_markers_bacteria.hmm D17.faa > SDB_one_sscmarkers.hmmsearch.txt
hmmsearch -E 0.00001 --domtblout ME_1_sscmarkers.domtblout.txt /data/DATABASES/SINGLE_COPY_GENE_HMMs/sc_markers_bacteria.hmm ME_1.faa > SDB_one_sscmarkers.hmmsearch.txt
hmmsearch -E 0.00001 --domtblout F21_sscmarkers.domtblout.txt /data/DATABASES/SINGLE_COPY_GENE_HMMs/sc_markers_bacteria.hmm F21.faa > SDB_one_sscmarkers.hmmsearch.txt


awk '{print $4}' SDB_one_sscmarkers.domtblout.txt | sort -u | wc -l
awk '{print $4}' SCADC_sscmarkers.domtblout.txt | sort -u | wc -l
awk '{print $4}' D17_sscmarkers.domtblout.txt | sort -u | wc -l
awk '{print $4}' ME_1_sscmarkers.domtblout.txt | sort -u | wc -l
awk '{print $4}' F21_sscmarkers.domtblout.txt | sort -u | wc -l

