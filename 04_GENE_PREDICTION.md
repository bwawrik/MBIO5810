Start a droplet in Digital Ocean and ssh into it.
Download the docker bwawrik/bioinformatics:latest

docker pull bwawrik/bioinformatics:latest

Make a data directory

mkdir /data

Start the docker and mount /data

docker run -t -i -v /data:/data bwawrik/bioinformatics:latest

Change your directory to /data

cd /data

Download the example metagenome data and assembly

wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/VIGDIS3_forward_paired.fq.gz
wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/VIGDIS3_reverse_paired.fq.gz
wget http://mgmic.oscer.ou.edu/sequence_data/tutorials/VigP03RayK31Contigs.fasta

gunzip *

Now make an output directory

mkdir /data/output

Predict ORFs as nucleotide (fna) and amio acid (faa) sequences using Prodigal

prodigal -d output/temp.orfs.fna -a output/temp.orfs.faa -i VigP03RayK31Contigs.fasta -m -o output/tempt.txt -p meta -q

cut -f1 -d " " output/temp.orfs.fna > output/VigP03RayK31.prodigal.orfs.fna

cut -f1 -d " " output/temp.orfs.faa > output/VigP03RayK31.prodigal.orfs.faa

rm -f output/temp*
You can do this separately by just call the ' -d output/temp.orfs.fna' or '-a output/temp.orfs.faa' flags.  The last command removes the temporary files.


Lets predict ORFs using FragGeneScan

First you need to copy the model files to the local directory. (This is a workaround; I'm not sure why it doesn't work without copying these files; sorry !)

mkdir Ftrain
cp /opt/local/software/FragGeneScan1.19/train/* Ftrain

Now lets predict the RFs

FragGene_Scan -s VigP03RayK31Contigs.fasta -o output/VigP03RayK31.FragGeneScan -w 1 -t complete

Clean up

rm -rf Ftrain

Now run the N50 script on both results.  Which one produces longers ORFs ? Which produces more ORFs ? Which is better ? Why ? What would be a better way to assess the quality of ORF calling ?

perl N50.pl output/VigP03RayK31.FragGeneScan.ffn
perl N50.pl output/VigP03RayK31.prodigal.orfs.fna

Retrieving your output

Log out of your droplet.  Then use secure copy (scp) to retrieve your files to your local drive. In this example, I used a droplet with the IP 45.55.160.193 and retrieved the files to my desktop on my macbook.  Make sure you replace this with the IP for your droplet. 

# scp root@45.55.160.193:/data/output/* ~/Desktop/

If you are using a PC, use an FTP program to retrieve your files.


