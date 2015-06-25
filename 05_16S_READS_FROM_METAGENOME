### Tutorial on extracting 16S reads from a metagenome

Start a droplet with at least 1GB of memory in Digital Ocean and ssh into it.
Download the docker bwawrik/bioinformatics:latest

docker pull bwawrik/biorinformatics:latest

Make a data directory

mkdir /data

Start the docker and mount /data

docker run -t -i -v /data:/data bwawrik/bioinformatics:latest

The first step it to deploy usearch. Since this software has to be licensed, so I can not include it in the docker, which is in a public repository.  Run the following commands to install a copy of usearch licensed to the wawrik lab. You can get your own license for free from the programs website. Please do so, if you are going to do this beyond the tutorials here.

cd /opt/local/software/
mkdir usearch
cd usearch
wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/usearch8.0.1517_i86linux32
chmod 777 *
cd /usr/local/bin
ln -s /opt/local/software/usearch/usearch8.0.1517_i86linux32 ./usearch

Now change to your data directory and make an output directory



Dowload the 16S database, read files, and the necessary perl scripts.

wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/VIGDIS3_forward_paired.50K.fq.gz
wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/parse_hits.pl
wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/VIGDIS3_reverse_paired.50K.fq.gz
wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/uclust_search_database.pl
gunzip *

Prepare your 16S database so you can search it by creating a UDB datase.

usearch -makeudb_usearch SSURef_111_candidate_db.fasta -output SSURef_111_candidate_db.udb

Alternatively, download the pre-compliled udb database:

wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/SSURef_111_candidate_db.udb

Now use the uclust_search_database.pl perl script to find all 16S containing reads in the read file you downloaded. The script extracts all reads that are >70% identical to any known sequence in Silva111.  If you would like to edit the parameter, you will need to edit the perl script directly. The input parameters for the perl script are as follows:
#my $ForwardReads  = $ARGV[0]; #my $ReverseReads  = $ARGV[1]; #my $database_path = $ARGV[2]; #my $output_name   = $ARGV[3];

perl uclust_search_database.pl VIGDIS3_forward_paired.50K.fq VIGDIS3_reverse_paired.50K.fq SSURef_111_candidate_db.udb Vig3_16Shits_usearch.fas

The Vig3_16Shits_usearch.fas output file contains the portions of reads that match sequences in the silva111 database. 
The Vig3_16Shits_usearch.fas.tags file contains the sequence identifiers for the sequences that contain a match in case you want to retrieve the complete reads.

Retrieving your output

Log out of your droplet and use secure copy (scp) to retrieve your files to your local drive. In this example, I used a droplet with the IP 45.55.160.193 and retrieved the files to my desktop on my macbook.  Make sure you replace this with the IP for your droplet. 

scp root@45.55.160.193:/data/Vig3_16Shits_usearch.fas ~/Desktop/
scp root@45.55.160.193:/data/Vig3_16Shits_usearch.fas.tags ~/Desktop/

If you are using a PC, use an FTP program to retrieve your files.

Determine taxonomic breakdown using the RDP Website

Go to : https://rdp.cme.msu.edu/
Click on 'Cl' Classifier
Paste the contents of Vig3_16Shits_usearch.fas into the text box and click classify.

The output should look something like this:

rootrank Root (304 sequences) [show assignment detail for Root only ]     
»  »  domain Archaea (4)
»  »  »  phylum "Euryarchaeota" (4)
»  »  »  »  class Archaeoglobi (2)
»  »  »  »  »  order Archaeoglobales (2)
»  »  »  »  class Thermococci (2)
»  »  »  »  »  order Thermococcales (2)
»  »  domain Bacteria (273)
»  »  »  phylum Firmicutes (4)
»  »  »  »  class Clostridia (3)
»  »  »  »  »  order Thermoanaerobacterales (2)
»  »  »  »  »  unclassified_Clostridia (1)
»  »  »  »  unclassified_Firmicutes (1)
»  »  »  phylum "Proteobacteria" (252)
»  »  »  »  class Deltaproteobacteria (6)
»  »  »  »  »  order Desulfovibrionales (6)
»  »  »  »  class Gammaproteobacteria (242)
»  »  »  »  »  order Thiotrichales (11)
»  »  »  »  »  order Alteromonadales (9)
»  »  »  »  »  order Oceanospirillales (13)
»  »  »  »  »  order Pseudomonadales (180)
»  »  »  »  »  unclassified_Gammaproteobacteria (29)
»  »  »  »  unclassified_"Proteobacteria" (4)
»  »  »  unclassified_Bacteria (17)
»  »  unclassified_Root (27)


