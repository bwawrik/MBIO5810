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

#### DOWNLOAD THE DATA FILES

```sh
https://github.com/bwawrik/MBIO5810/raw/master/sequence_data/SDB_ONE.faa
https://github.com/bwawrik/MBIO5810/raw/master/sequence_data/F21.faa.gz
gunzip F21.faa.gz

```

#### RUN THE HMM SEARCH

I'm giving you two fasta files here of predicted amino acid sequences.  These are derived from genome bins, one from a metagenome (SDB_ONE.faa), the other from single cell genomcis experiments (.


DO THE HMM SEARCH


```sh 
hmmsearch -E 0.0000000001 --domtblout SDB_one_sscmarkers.domtblout.txt /data/DATABASES/SINGLE_COPY_GENE_HMMs/sc_markers_bacteria.hmm SDB_ONE.faa > SDB_one_sscmarkers.hmmsearch.txt
```

FIND ALL THE HITS

```sh
cat SDB_one_sscmarkers.domtblout.txt | sed '/^#/ d' | awk '{print $4}'
```

UNIQUE HITS

```sh
cat SDB_one_sscmarkers.domtblout.txt | sed '/^#/ d' | awk '{print $4}' | sort -u
```

COUNT THEM

```sh
cat SDB_one_sscmarkers.domtblout.txt | sed '/^#/ d' | awk '{print $4}' | sort -u | wc -l
```





