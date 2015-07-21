### Tutorial to identify and remove chimeric and mitochondrial 16S reads in 16S amplicon data

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
gunzip *.gz
```


- Join the fastq files to stich reads together (Note: p: percent maximum difference; m: minimum overlap; o: output directory)

```sh
fastq-join  GOM_R1.fastq  GOM_R2.fastq -p 3 -m 50 -o GoM_16S_Sept.fastq
mv  GoM_16S_Sept.fastqjoin  GoM_16S_Sept.fastq
```

- Extract your reads and barcodes

```sh
extract_barcodes.py -f GoM_16S_Sept.fastq -m GoM_Sept_Mapping.txt --attempt_read_reorientation -l 12 -o processed_seqs
```

- Split libraries

```sh
split_libraries_fastq.py -i processed_seqs/reads.fastq -b processed_seqs/barcodes.fastq -m  GoM_Sept_Mapping.txt -o processed_seqs/Split_Output/ --barcode_type 12
```

### DEFAULT QIIME ANALYSIS USING GREENGENES

- Pick your OTUs

```sh
pick_open_reference_otus.py -i processed_seqs/Split_Output/seqs.fna -o OTUs
```

- Inspect the BIOM file

```sh
biom summarize-table -i OTUs/otu_table_mc2_w_tax_no_pynast_failures.biom
```

- Run QIIME core diversity analysis

```sh
core_diversity_analyses.py -o cdout/ -i  OTUs/otu_table_mc2_w_tax_no_pynast_failures.biom -m GoM_Sept_Mapping.txt -t OTUs/rep_set.tre -e 20
```

- Retrieving your output

Log out of your VM.  Then use secure copy (scp) to retrieve your files to your local drive. In this example, I used a droplet with the IP 45.55.160.193 and retrieved the files to my desktop on my macbook.  Make sure you replace this with the IP for your droplet. If you are using a PC, use an FTP program to retrieve your files.

```sh
scp -r root@45.55.160.193:/data/cdout/* ~/Desktop/
```

### QIIME ANALYSIS USING SILVA 111

The commands above use a closed reference OTU picking approach with a pre-deployed version of Greengenes at 90% identity. Lets Do this with Silva 111 and open reference picking now.  

- Start by deploying the Silva111 database:

```sh
mkdir -p /data/DATABASES/16S
cd /data/DATABASES/16S
wget http://www.arb-silva.de/fileadmin/silva_databases/qiime/Silva_111_release.tgz
tar -xvf Silva_111_release.tgz
cd Silva_111_post/rep_set_aligned
gunzip *
cd ..
cd rep_set
gunzip *
```

- Download the parameters file needed for running the analysis using Silva

```sh
wget https://github.com/bwawrik/MBIO5810/raw/master/sequence_data/qiime_parameters_silva111.par
```

- Pick your OTUs

```sh
pick_de_novo_otus.py -i processed_seqs/Split_Output/seqs.fna -o OTUs_silva -p qiime_parameters_silva111.par
```

- Inspect the BIOM file

```sh
biom summarize-table -i OTUs_silva/otu_table.biom 
``` 

Look at the number of sequences in each sample.  In the next command you need to set the '-e' parameter, which is the sampling depth for rarefaction.  'e' should not exceed the lowest number in the result form this command.

- Run QIIME core diversity analysis

```sh
core_diversity_analyses.py -o cdout_silva/ -i  OTUs_silva/otu_table.biom -m GoM_Sept_Mapping.txt -t OTUs_silva/rep_set.tre -e 20
```
