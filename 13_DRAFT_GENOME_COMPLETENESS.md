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
wget https://github.com/bwawrik/MBIO5810/raw/master/sequence_data/SDB_ONE.faa
wget https://github.com/bwawrik/MBIO5810/raw/master/sequence_data/F21.faa.gz
wget https://github.com/bwawrik/MBIO5810/raw/master/sequence_data/sc_markers_bacteria.hmm
gunzip F21.faa.gz
```

#### RUN THE HMM SEARCH

I'm giving you two fasta files here of predicted amino acid sequences.  These are derived from genome bins, one from a metagenome (SDB_ONE.faa), the other from single cell genomcis experiments (F21.faa).  The .hmm file contains the models for 111 single copy markger genes found in all bacteria.

- The first step is to run an HMM search of your HMM models agains each of the amino acid sequences. I'm applying an E score of 1E-10 here. This is relatively conservative. The commands below are for the SDB_ONE.faa file.

```sh 
hmmsearch -E 0.0000000001 --domtblout SDB_one_sscmarkers.domtblout.txt /data/DATABASES/SINGLE_COPY_GENE_HMMs/sc_markers_bacteria.hmm SDB_ONE.faa > SDB_one_sscmarkers.hmmsearch.txt
```

"--domblout" creates a tab delimited output file which we will use to count the number of unique hits.  The other file contains the complete HMM search output in case you are interested in it.

#### COUNT THE NUMBER OF UNIQUE HITS

- Lets break down the --domblout output

```sh
cat SDB_one_sscmarkers.domtblout.txt | sed '/^#/ d' | awk '{print $4}'
```

The 'sed' command removes all annoation lines, which start with a '#' character.
the 'awk' command extracts the fourth column, which contains the single copy marker gene identifiers.


- We can get the UNIQUE HITS using 'sort'

```sh
cat SDB_one_sscmarkers.domtblout.txt | sed '/^#/ d' | awk '{print $4}' | sort -u
```

- All that is left is to count them

```sh
cat SDB_one_sscmarkers.domtblout.txt | sed '/^#/ d' | awk '{print $4}' | sort -u | wc -l
```

#### SELF EVALUATION

- Run the analysis for the F21.faa file. Which is more complete, F21 or SDB ?
- Run the analysis on a complete genome you obtain from Genbank. Can you find all 111 single copy marker genes ?



