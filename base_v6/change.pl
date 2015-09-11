#!/usr/bin/perl -w
use strict;

my ($blast_out) = @ARGV;
my $usage = "This script is to get the best hit from blast output file with 1 input sequence.
usage: $0 <blast_output_file>
";
die $usage if @ARGV<1;

open(BLASTOUT,$blast_out)||die("open $blast_out error!\n");
open(FILE, ">haha.txt");
my $sen1="";
my $sen2="";
my $i=0;

while(<BLASTOUT>){
    chomp;
	print FILE $_,"|\n";
}

close BLASTOUT;
close FILE;
exit;