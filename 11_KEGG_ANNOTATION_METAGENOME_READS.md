Start a droplet with at least 1GB of memory in Digital Ocean and ssh into it.

Alternatively (and better) install and use boot2docker.

 

Download the docker bwawrik/bioinformatics:latest

 

docker pull bwawrik/bioinformatics:latest

 

Make a data directory

 

mkdir /data

 

Start the docker and mount /data

 

docker run -t -i -v /data:/data bwawrik/bioinformatics:latest

 

Change your directory to /data

 

cd /data

 

Retrieving your data

 

wget http://mgmic.oscer.ou.edu/sequence_data/KoGenes

 

wget http://mgmic.oscer.ou.edu/sequence_data/ ko_pep.fasta

 

wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/VIGDIS3_forward_paired.50K.fasta

wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/VIGDIS3_reverse_paired.50K.fasta

 

cat VIGDIS3_forward_paired.50K.fasta VIGDIS3_reverse_paired.50K.fasta > VIGDIS_50K.fasta

 

The newly concatenated VIGDIS_50K.fasta file will be used for all downstream unassembled read analyses. You will need to retrieve your predicted orfs from Tutorial #4.

 

Annotating your data based on the KEGG Protein Database:

 

You can choose to annotate your metagenome using either the unassembled reads or the predicted orfs from your assembly. There are strengths and limitations to each approach, so consider these carefully when analyzing your own datasets. The following illustrates both strategies.

 

Approach 1: Annotation of unassembled reads using Diamond:

 

Create the KEGG diamond-formatted database:

 

diamond --in ko_pep.fasta –d ko_pep

 

*Note: This creates a new database named ko_pep.dmnd. You do not need to use the file extension when calling this database in future diamond analyses.

 

Diamond comparison of your reads against the newly created database

 

mkdir temp/

 

diamond blastx –q VIGDIS_50K.fasta –d ko_pep –k 1 –e 0.00001 --sensitive –t temp/ -o VIGDIS_50K _diamond_ko.txt

 

*Note:  This translates each read in all 6 frames and then uses the "best" frame for comparison against the database.  Results are limited by an evalue of 1e-5 and reports only the top hit operating in sensitive mode.  This output is in the Blast_6 format and contains the hit to KEGG GENE_ID that can be directly compared to the KEGG KO alias database file for KEGG KO annotation of the entire dataset. For detailed explanation see (http://ab.inf.uni-tuebingen.de/data/software/diamond/download/public/manual.pdf)

 

Create KEGG Orthology counts from annotated search reports:

Prepare diamond output for use in sqlite database.

 

cut -f 2 VIGDIS_50K _diamond_ko.txt > VIGDIS_50K _gene_hits.txt

 

This command cuts only the second field from the dataset and creates a new list from the cut data.

 

 

Create sqlite database for each analysis

 

sqlite3 VIGDIS_50K_ko.sqlite

 

This opens sqlite and you should see a screen output like this:

 

sqlite3 VIGDIS_50K_ko.sqlite

SQLite version 3.8.2 2013-12-06 14:53:30

Enter ".help" for instructions

Enter SQL statements terminated with a ";"

sqlite>

 

Specify desired delimiter

 

.separator " "

 

This tells sqlite to use space-delimited files as the expected structure for imports (KoGenes) or exports.

Create KO table within new sqlite database

 

create table KoGenes (KO, gene);

.import KoGenes KoGenes

 

This created a table for the Kegg gene orthology aliases and then populated it with the data imported from the file KoGenes

 

Create table from gene hits from dataset within sqlite database

 

create table VIGDIS_50K _hits (hit);

.import VIGDIS_50K _gene_hits.txt sdh_hits

 

Create analysis table that sums the number of KOs observed within a given dataset

 

create table KO_counts as select b.KO as KO, count(b.KO) as count

   ...> from VIGDIS_50K _hits as a, KoGenes as b

   ...> where a.hit = b.gene

   ...> group by b.KO order by b.KO;

 

You should hit “return” after each line is entered. The “…>” notation denotes each line is a portion of the above statement.

 

Writing analysis table to text file

 

.separator "\t"

.output VIGDIS_50K_KO_counts.txt

select * from KO_counts;

 

You should now see a tab-delimited text file with all of the KEGG orthologies annotated from your dataset and the number of times that orthology was encountered. 
