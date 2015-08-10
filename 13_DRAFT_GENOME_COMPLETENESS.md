DO THE HMM SEARCH

hmmsearch -E 0.0000000001 --domtblout SDB_one_sscmarkers.domtblout.txt /data/DATABASES/SINGLE_COPY_GENE_HMMs/sc_markers_bacteria.hmm SDB_ONE.faa > SDB_one_sscmarkers.hmmsearch.txt

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

