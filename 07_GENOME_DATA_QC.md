### QC OF GENOME AND METAGENOME DATA BEFORE DOWNSTREAM ANALYSIS (e.g. assemlby or gene prediction)

- Download the docker bwawrik/bioinformatics:latest

```sh
docker pull bwawrik/bioinformatics:latest
```

- Make a data directory and mount it into the docker 

```sh
mkdir /data
docker run -t -i -v /data:/data bwawrik/bioinformatics:latest
cd /data
```

- Download the sample genome data set 

```sh
wget https://github.com/bwawrik/MBIO5810/raw/master/sequence_data/232_R1_40k.fastq.gz
wget https://github.com/bwawrik/MBIO5810/raw/master/sequence_data/232_R2_40k.fastq.gz
```

Make an analysis directory

```sh
mkdir fastqc_before
```

- Now run fastQC on your pre-trimming data and unzip the results

```sh
fastqc 232_R1_40k.fastq -o fastqc_before/
fastqc 232_R2_40k.fastq -o fastqc_before/
cd fastqc_before
unzip 232_R1_40k_fastqc.zip
unzip 232_R2_40k_fastqc.zip
```

- You will need to create a configuration file.  The information you need is in the report files under 'overrepresented sequences'. If you can use a web browser, open the report html file and cut and paste into nano. If you can't catenate the output file and use nano to edit

```sh
cat  fastqc_before/232_R1_40k_fastqc/fastqc_data.txt fastqc_before/232_R1_40k_fastqc/fastqc_data.txt > cutadapt.conf
```

- Open the file with nano and use 'Ctrl K' to delete all lines that do not contain the overrepresented sequence information. You will then need to manually edit the file to addd the -e -q and -n paramerts.  Your final file should look like this:

```sh
-b GATCGGAAGAGCACACGTCTGAACTCCAGTCACGTCCGCACATCTCGTAT
-b AGATCGGAAGAGCACACGTCTGAACTCCAGTCACGTCCGCACATCTCGTA
-b GATCGGAAGAGCACACGTCTGAACTCCAGTCACGTCCGCACATATCGTAT
-b AGATCGGAAGAGCACACGTCTGAACTCCAGTCACGTCCGCACATATCGTA
-b AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCC
-e 0.15 
-q 30
-n 3
```

- For the sample data, you can download the .conf file here, if you are having trouble:

```sh
wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/cutadapt.conf
```sh

Now trim your adapters off your data
cutadapt $(<cutadapt.conf) 232_R1_40k.fastq > 232_R1_40k.cutadapt.fastq
cutadapt $(<cutadapt.conf) 232_R2_40k.fastq > 232_R2_40k.cutadapt.fastq


The next step is to quality trim your data to a Q-score of 30

read_fastq -e base_33 -i 232_R1_40k.cutadapt.fastq | trim_seq -m 30 | write_fastq -o 232_R1_40k.cutadapt.q30.fastq -x
read_fastq -e base_33 -i 232_R2_40k.cutadapt.fastq | trim_seq -m 30 | write_fastq -o 232_R2_40k.cutadapt.q30.fastq -x

Occasionally the MySeq will have some poly-A artifacts. I'm not sure why, but I think they are created by read-through. Lets remove them.

homerTools trim -3 AAAAAA 232_R1_40k.cutadapt.q30.fastq
homerTools trim -3 AAAAAA 232_R2_40k.cutadapt.q30.fastq

One last step is to extract the paired reads only.  Experience tells me that unpaired reads are poor quality. We'll trim to minimum length of 50 bp and crop to max length of 250 bp. Remember to crop to the appropriate length.

trimmomatic PE -phred33 232_R1_40k.cutadapt.q30.fastq.trimmed 232_R2_40k.cutadapt.q30.fastq.trimmed 232_R1_40k.qc.paired.fastq 232_R1_40k.qc.unpaired.fastq 232_R2_40k.qc.paired.fastq 232_R2_40k.qc.unpaired.fastq MINLEN:50 CROP:250

Rerun your fastqc analysis


mkdir fastqc_after

fastqc 232_R2_40k.qc.paired.fastq -o fastqc_after/
fastqc 232_R1_40k.qc.paired.fastq -o fastqc_after/

Use a web-browser to inspect the before and after files
