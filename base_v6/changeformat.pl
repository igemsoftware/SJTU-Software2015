#!/usr/bin/perl -w
use strict;

my ($blast_out) = @ARGV;
my $usage = "This script is to get the best hit from blast output file with 1 input sequence.
usage: $0 <blast_output_file>
";
die $usage if @ARGV<1;

open(BLASTOUT,$blast_out)||die("open $blast_out error!\n");
open(FILE, ">conscore_v1.txt");
my $sen1="";
my $sen2="";
my @sen = ();
my $i=0;

while(<BLASTOUT>){
    chomp;
	@sen=split(/\t/,$_);
	if($sen[0] eq $sen[1]){
	}else{
		print FILE $sen[0],"|",$sen[1],"|",$sen[2],"|",$sen[4],"|",$sen[5],"|\n";
	}
}

close BLASTOUT;
close FILE;
exit;