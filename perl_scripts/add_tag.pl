#-----------------------------------------------------------------------------
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

my @barcodes = get_file_data ("barcodes.txt");
chomp @barcodes;

my $m_thirteen_primer = "CGTAAAACGACGGCCAG";
my $spacer = "CC";

#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------

my $tag_number = $ARGV [0];
my $filenameA = $ARGV[1];
#my $name_tag = $ARGV[2];

open my $FILEA, "< $filenameA";

$filenameA =~ s/.fasta//g;
my $filenameOut = $filenameA.$barcodes[$tag_number].".fasta";
open my $OUTFILE, "> $filenameOut";

while (<$FILEA>)
{
my $sts = $_; 
chomp ($sts); 
# $sts .= $name_tag;
$sts =~ s/-/:/g;
#$sts =~ s/>//g;
#my $h = $ARGV[1]; $h =~ s/.fas//; $h =~ s/.fasta//;
#$sts = ">".$sts . " orig_bc=".$barcodes[$tag_number]." new_bc=".$barcodes[$tag_number]." bc_diffs=0\n"; 
print $OUTFILE $sts."\n";
$_ = <$FILEA>;
print $OUTFILE $barcodes[$tag_number].$spacer.$m_thirteen_primer.$_;

}
close $FILEA;
close $OUTFILE;


#-----------------------------------------------------------------------------
#--make mapping file----------------------------------------------------------
#-----------------------------------------------------------------------------


my @mapping;

push (@mapping, "#SampleID\tBarcodeSequence\tLinkerPrimerSequence\tTreatment\tDescription");
push (@mapping, "#Descriptive string identifying the sample  ");
#my $h = $ARGV[1]; $h =~ s/.fas//; $h =~ s/.fasta//;
#push (@mapping, $h."\t".$barcodes[$tag_number]."\t".$spacer.$m_thirteen_primer."\ttest\tnone");
push (@mapping, "sample".$barcodes[$tag_number]."\t".$barcodes[$tag_number]."\t".$spacer.$m_thirteen_primer."\ttest\tnone");

WriteArrayToFile ($filenameA.".map", @mapping);






