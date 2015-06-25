### QIIME ANALYSIS OF 16S CONTAINING READS IN A METAGENOME

- Start a VM with at least 1GB of memory and ssh into it.Alternatively (and better) install and use boot2docker.

- Download the docker bwawrik/bioinformatics:latest

```sh
docker pull bwawrik/bioinformatics:latest
```

- Make a data directory. if you are working locally on a mac using boot2docker you will need to work in ~/data. Please replace where appropriate

```sh
mkdir /data
(* on  your mac: mkdir ~/data)
```

- Start the docker and mount /data

```sh
docker run -t -i -v /data:/data bwawrik/bioinformatics:latest
(* locally on mac: docker run -t -i -v ~/data:/data bwawrik/bioinformatics:latest)
```

 
- Install usearch8.0.1517 (the following will not work with older usearch versions)

```sh
mkdir -p /opt/local/software/usearch
cd /opt/local/software/usearch
wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/usearch8.0.1517_i86linux32
chmod 777 *
cd /usr/local/bin
ln -s /opt/local/software/usearch/usearch8.0.1517_i86linux32 ./usearch8
```

- Install the Silva111 database
 
```sh
mkdir -p /data/DATABASES/16S
(* on  your mac: mkdir -p ~/data/DATABASES/16S)
cd /data/DATABASES/16S
(* on  your mac: cd ~/data/DATABASES/16S)
wget http://www.arb-silva.de/fileadmin/silva_databases/qiime/Silva_111_release.tgz
tar -xvf Silva_111_release.tgz
cd Silva_111_post/rep_set_aligned
gunzip *cd ..cd rep_set
gunzip *
```
 
Now change to your data directory and make an output directory

cd /data
(* on  your mac: cd ~/data)
 
Dowload the 16S database, read files, and the necessary perl scripts.

wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/VIGDIS3_forward_paired.50K.fq
wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/VIGDIS3_reverse_paired.50K.fq
gunzip *
 
Convert fastq files to fasta
 
read_fastq -i VIGDIS3_reverse_paired.50K.fq | write_fasta -o VIGDIS3_reverse_paired.50K.fasta -x
read_fastq -i VIGDIS3_forward_paired.50K.fq | write_fasta -o VIGDIS3_forward_paired.50K.fasta -x


Download the pre-compiled udb database:
 
wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/SSURef_111_candidate_db.udb

Now run your usearch command

usearch8 -usearch_global VIGDIS3_forward_paired.50K.fasta -db SSURef_111_candidate_db.udb -qsegout f_ssu_hits.fasta -blast6out f_ssu_hits.txt -strand both -id 0.7 -maxhits 1

usearch8 -usearch_global VIGDIS3_reverse_paired.50K.fasta -db SSURef_111_candidate_db.udb -qsegout r_ssu_hits.fasta -blast6out r_ssu_hits.txt -strand both -id 0.7 -maxhits 1

*Note:  outputs a fasta file containing only the aligned region of each query and a table of the search match criteria

Reformat the resulting fasta files to avoid seqID duplication errors

sed -i 's/>/>f_/g' f_ssu_hits.fasta
sed -i 's/>/>r_/g' r_ssu_hits.fasta

Catentating the forward and reverse ssu query segments into a single file

cat f_ssu_hits.fasta r_ssu_hits.fasta > ssu_hits.fasta

Removing any extraneous line returns that USEARCH may have added within sequences using Biopieces

read_fasta -i ssu_hits.fasta | write_fasta -o ssu_hits_corrected.fasta -x
 
Download the docker bwawrik/qiime:latest

docker pull bwawrik/qiime:latest

Start the docker and mount /data

docker run -t -i -v /data:/data bwawrik/qiime:latest
(* locally on mac: docker run -t -i -v ~/data:/data bwawrik/qiime:latest)
 
You will also need a barcodes file, the add_tag.pl script, and a script to remove duplicates

cd data
(* on  your mac: cd ~/data)
wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/qiime_jamie/barcodes.txt
wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/qiime_jamie/add_tag.pl
wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/qiime_jamie/qiime_default.par

Then add a barcode from the barcodes.txt file.  Lets use the third one in the list.

perl add_tag.pl 3 ssu_hits_corrected.fasta

Validate the mapping file

validate_mapping_file.py -m ssu_hits_corrected.map -o mg_mapping

Split libraries

split_libraries.py -f ssu_hits_correctedATCACCAGGTGT.fasta -m  ssu_hits_corrected.map -o mg_processed_seqs/ --barcode_type 12

Validate the fasta file

validate_demultiplexed_fasta.py -i mg_processed_seqs/seqs.fna -m  ssu_hits_corrected.map
cat seqs.fna_report.log

Lets pick our OTUs and assign taxonomy via closed reference picking
note: closed reference is necessary, because reads don't overlap;
 
pick_closed_reference_otus.py -i mg_processed_seqs/seqs.fna -o mg_OTUs -r /data/DATABASES/16S/Silva_111_post/rep_set/97_Silva_111_rep_set.fasta  -t /data/DATABASES/16S/Silva_111_post/taxonomy/97_Silva_111_taxa_map_RDP_6_levels.txt -f
(* on  your mac: pick_closed_reference_otus.py -i mg_processed_seqs/seqs.fna -o mg_OTUs -r ~/data/DATABASES/16S/Silva_111_post/rep_set/97_Silva_111_rep_set.fasta  -t ~/data/DATABASES/16S/Silva_111_post/taxonomy/97_Silva_111_taxa_map_RDP_6_levels.txt -f)

Inspect the BIOM file

biom summarize-table -i mg_OTUs/otu_table.biom
 
Make a pie chart

summarize_taxa_through_plots.py -i mg_OTUs/otu_table.biom -o mg_taxplots -m  ssu_hits_corrected.map -p qiime_default.par -f

The parameters file contains one line:
plot_taxa_summary:chart_type bar
If you would like to make a pie chart instead, edit the the parameters file with nano to:
plot_taxa_summary:chart_type pie
