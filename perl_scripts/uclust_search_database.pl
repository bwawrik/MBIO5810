#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
# Perl script to conduct usearch of fasta file on udb database
# Author: Boris Wawrik
#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------


#!/usr/bin/perl
use strict;
use warnings;
#--INCLUDE PACKAGES-----------------------------------------------------------
use IO::String;
#-----------------------------------------------------------------------------
#----SUBROUTINES--------------------------------------------------------------
#-----------------------------------------------------------------------------
sub get_file_data
    {
    my ($file_name) = @_;
    my @file_content;
    open (PROTEINFILE, $file_name);
    @file_content = <PROTEINFILE>;
    close PROTEINFILE;
    return @file_content;
    } # end of subroutine get_file_data;

sub WriteArrayToFile
    {
    my ($filename, @in) = @_;
    my $a = join (@in, "\n");
    open (OUTFILE, ">$filename");
    foreach my $a (@in)
      {
      print OUTFILE $a;
      print OUTFILE "\n";
      }
    close (OUTFILE);
     }

#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------

my $ForwardReads  = $ARGV[0];
my $ReverseReads  = $ARGV[1];
my $database_path = $ARGV[2];
my $output_name   = $ARGV[3];
my $id = 0.7;

system("mkdir temp");

#-----------------------------------------------------------------------------
#------create fasta files-----------------------------------------------------
#-----------------------------------------------------------------------------

system ("read_fastq -i ".$ForwardReads." | write_fasta -o temp/fr.fasta -x");
system ("read_fastq -i ".$ReverseReads." | write_fasta -o temp/rr.fasta -x");

#-----------------------------------------------------------------------------
#------run usearch commands----------------------------------------------------
#-----------------------------------------------------------------------------


my $commandline = "usearch -usearch_global temp/fr.fasta -db ".$database_path." -id ".$id." -fastapairs temp/f_hits.fasta -strand both";
system ($commandline);

$commandline = "usearch -usearch_global temp/rr.fasta -db ".$database_path." -id ".$id." -fastapairs temp/r_hits.fasta -strand both";
system ($commandline);

#-----------------------------------------------------------------------------
#------parse my hits----------------------------------------------------------
#-----------------------------------------------------------------------------

printf "parsing hits\n";
system ("perl parse_hits.pl temp/f_hits.fasta temp/fhits_only.fasta");
system ("perl parse_hits.pl temp/r_hits.fasta temp/rhits_only.fasta");
system ("cat temp/fhits_only.fasta temp/rhits_only.fasta > ".$output_name);
system ("cat temp/fhits_only.fasta.tags temp/rhits_only.fasta.tags > ".$output_name.".tags");

#-----------------------------------------------------------------------------
#--extract the matching reads-------------------------------------------------
#-----------------------------------------------------------------------------

$output_name =~ s/".fasta"//g;

system ("read_fasta -i temp/fr.fasta | grab -E ".$output_name.".tags | write_fasta -o ".$output_name.".fseqs.fasta -x");
system ("read_fasta -i temp/rr.fasta | grab -E ".$output_name.".tags | write_fasta -o ".$output_name.".rseqs.fasta -x");


#-----------------------------------------------------------------------------
#clearnup
#-----------------------------------------------------------------------------

system ("rm -rf temp/");



