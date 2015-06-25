#------------------------------------------
#------------------------------------------
# Perl script that parses usearch hits 
# Author : Boris Wawrik
#------------------------------------------
#------------------------------------------
#!/usr/bin/perl

#------------------------------------------
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
#-------------------------------------------


$filenameA = $ARGV[0];
$filenameOut = $ARGV[1];
my @identarray;

open $FILEA, "< $filenameA";
open $OUTFILE, "> $filenameOut";
open $TEMP, ">temp.temp";

while (<$FILEA>)
{
my $a=$_;
$a =~s/-//g;
my @aa = split(//,$a); 
if ($aa[0] eq ">") { print $TEMP $_ unless $_ eq "\n"; }
else {print $TEMP $a unless $a eq "\n";}

}

close $TEMP;
open $TEMP, "<temp.temp";

while(<$TEMP>) {
        print $OUTFILE $_;
        my $a=$_; chomp $a; my @aa = split(//,$a); if ($aa[0] eq ">") {$a =~s/>//g; push (@identarray, $a);}
        $_ = <$TEMP>;
        print $OUTFILE $_;
        $a=$_;chomp $a; @aa = split(//,$a); if ($aa[0] eq ">") {$a =~s/>//g; push (@identarray, $a);}
        $_ = <$TEMP>;
#        print $OUTFILE $_;
        $_ = <$TEMP>;
#        print $OUTFILE $_;
}
close $TEMP;
system ("rm temp.temp");
close $FILEA;
close $OUTFILE;
WriteArrayToFile($filenameOut.".tags", @identarray);

 
 


