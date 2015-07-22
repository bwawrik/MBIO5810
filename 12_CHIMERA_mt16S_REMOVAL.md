#### Tutorial to identify and remove chimeric and mitochondrial 16S reads in 16S amplicon data

NOTE:
THIS TUTORIAL WILL NOT RUN WITH LESS THAN 4GB OF RAM.
RUN A VM OR LOCAL MACHINE WITH THE APPROPRIATE MEMORY SIZE.
ALTERNATIVELY, INSTALL Boot2Docker AND RUN THIS TUTORIAL LOCALLY.

- Launch an appropriately sized VM
- Install the Silva111 database if its not installed yet

```sh 
mkdir -p /data/DATABASES/16S
cd /data/DATABASES/16S
wget http://www.arb-silva.de/fileadmin/silva_databases/qiime/Silva_111_release.tgz
tar -xvf Silva_111_release.tgz
cd Silva_111_post/rep_set_aligned
gunzip *cd ..
cd rep_set
gunzip *
```

- Download the docker bwawrik/qiime:latest and launch it, mounting the data directory

```sh
docker pull bwawrik/qiime:latest
root@bioinformatics:~# docker run -t -i -v ~/data:/data bwawrik/qiime:latest
```

- Deploy usearch version 5.2.236 and 6.1.544. Qiime does not use the latest version of usearch and will throw an error if you try to use it. Since this software has to be licensed, so I can not include it in the docker, which is in a public repository.  Run the following commands to install usearch licensed to the Wawrik lab. Please get your own license for free from the programs website, if you are going to do this beyond the tutorial described here.

```sh
wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/install_usearch.sh
sh install_usearch.sh
```

- The install_usearch.sh shell script contain the following commands, in case you want to do this manually:

```sh
mkdir -p /opt/local/software/usearch 
cd /opt/local/software/usearch 
wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/usearch5.2.236_i86linux32
wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/usearch6.1.544_i86linux32
chmod 777 * 
cd /usr/local/bin 
ln -s /opt/local/software/usearch/usearch5.2.236_i86linux32 ./usearch 
ln -s /opt/local/software/usearch/usearch6.1.544_i86linux32 ./usearch61
```

- Change your directory to /data and dowload sample data as well the mapping file

```sh

cd /data
wget https://github.com/bwawrik/MBIO5810/raw/master/sequence_data/rock_50k_R1.fastq.gz
wget https://github.com/bwawrik/MBIO5810/raw/master/sequence_data/rock_50k_R2.fastq.gz
wget https://github.com/bwawrik/MBIO5810/raw/master/misc_files/rocktype.map
wget https://github.com/bwawrik/MBIO5810/raw/master/sequence_data/qiime_parameters_silva111.par
gunzip *.gz
```


- Join the fastq files to stich reads together (Note: p: percent maximum difference; m: minimum overlap; o: output directory)

```sh
fastq-join  rock_50k_R1.fastq  rock_50k_R2.fastq -p 3 -m 50 -o rock_joined
mv  rock_joinedjoin rock_joined.fastq
```

- Extract your reads and barcodes

```sh
extract_barcodes.py -f rock_joined.fastq -m rocktype.map --attempt_read_reorientation -l 12 -o processed_seqs
```

- Split libraries

```sh
split_libraries_fastq.py -i processed_seqs/reads.fastq -b processed_seqs/barcodes.fastq -m rocktype.map -o processed_seqs/Split_Output/ --barcode_type 12
```

#### PICK OTUS USING QIIME 

The defaule for qiime is to use Greengenes at 90% identity. I prefer using Silva open reference picking; at least I tend to have gotten better results wih the Silva allignment. I typically use Silva111. 

- Pick your OTUs

```
pick_de_novo_otus.py -i processed_seqs/Split_Output/seqs.fna -o OTUs_silva -p qiime_parameters_silva111.par
```

#### IDENFIFY CHIMERIC SEQUENCES
```
identify_chimeric_seqs.py -m usearch61 -i OTUs_silva/rep_set/seqs_rep_set.fasta -r /data/DATABASES/16S/Silva_111_post/rep_set/90_Silva_111_rep_set.fasta -o chimeric_seqs/
```
The output here produces two files in the chimeric_seqs/ folder
- 'chimeras.txt' contains the identifiers of the OTUs that are chimeric
- 'non_chimeras.txt' contains the identifiers of the non-chimeric OTUs (the ones you want to keep)

#### IDENIFY SEQUECNES THAT ARE MITOCHONDRIAL IN ORIGIN

```
mkdir metaxa_output
cd metaxa_output
metaxa -i /data/OTUs_silva/rep_set/seqs_rep_set.fasta -o metaxa_output/
```
The metaxa folder will contain a series of files. Depending what you want to use, keep, or remove, you will have ot make a judement how to use them:  For the purpose of this tutorial, we will remove mitochonridal OTUs from the data.
```
metaxa_output_alignments/                          22-Jul-2015 02:23                   -
metaxa_output.archaea.fasta                        22-Jul-2015 02:23                 336
metaxa_output.bacteria.fasta                       22-Jul-2015 02:23               35560
metaxa_output.chloroplast.fasta                    22-Jul-2015 02:23                1691
metaxa_output.eukaryota.fasta                      22-Jul-2015 02:23                   0
metaxa_output.extraction.fasta                     22-Jul-2015 02:22               56949
metaxa_output.extraction.results                   22-Jul-2015 02:22               25975
metaxa_output.graph                                22-Jul-2015 02:22               63258
metaxa_output.mitochondria.fasta                   22-Jul-2015 02:23                7937
metaxa_output.summary.txt                          22-Jul-2015 02:23                3134
metaxa_output.uncertain.fasta                      22-Jul-2015 02:23                 764
```

or the purpose of this tutorial, we will remove mitochonridal OTUs from the data. This requires that you get a list of the OTU identifiers from the 'metaxa_output.mitochondria.fasta' file:
```
grep -e ">" metaxa_output.mitochondria.fasta | sed 's/>//g' | sed 's/ /\t/g' | cut -f 1 > metaxa_output.mitochondria.ids
```

#### REMOVING THE CONTAMINATING READS

- first, lets filter out the chimeric seqs by keeping all non-chimeric OTUs
note: for qiime documentations see : "http://qiime.org/scripts/filter_otus_from_otu_table.html"

```
filter_otus_from_otu_table.py -i OTUs_silva/otu_table.biom -o OTUs_silva/otu_table.no_chimeras.biom -e chimeric_seqs/non_chimeras.txt --negate_ids_to_exclude
```
- Now remove all OTUs that look like mitochondrial sequences
```
filter_otus_from_otu_table.py -i OTUs_silva/otu_table.no_chimeras.biom -o OTUs_silva/otu_table.no_chimeras.no_mt.biom -e metaxa_output/metaxa_output.mitochondria.ids 
```

#### COMPLETE THE QIIME BREAKDOWN

- Inspect the BIOM files

```sh
biom summarize-table -i OTUs_silva/otu_table.biom 
biom summarize-table -i OTUs_silva/otu_table.no_chimeras.biom
biom summarize-table -i OTUs_silva/otu_table.no_chimeras.no_mt.biom

``` 

Look at the number of sequences in each sample.  In the next command you need to set the '-e' parameter, which is the sampling depth for rarefaction.  'e' should generally not exceed the lowest number in the result form this command. Lets use 20 here, though, since really small values can also lead to failure of the analysis.

- Run QIIME core diversity analysis

```sh
core_diversity_analyses.py -o cdout_silva_original/ -i  OTUs_silva/otu_table.biom -m rocktype.map -t OTUs_silva/rep_set.tre -e 20

core_diversity_analyses.py -o cdout_silva_corrected/ -i  OTUs_silva/otu_table.no_chimeras.no_mt.biom -m rocktype.map -t OTUs_silva/rep_set.tre -e 20

```
- Your qiime output without removal of chimeric or mitochondrial sequences will be in 'cdout_silva_original/'
- Your qiime output after removal of chimeric or mitochondrial sequences will be in 'cdout_silva_corrected/'


#### SELF EXAMINATION

- Does this data set contain a lot of chimeras ?
- Does it contain significant mitochrondial and chloroplast contamination ?
- Rerun the diversity analysis on the original OTUs_silva/otu_table.biom file. Is it different ? Why ?
- Is significant mitochrondial and chloroplast contamination a common problem ? When might you suspect it ?
