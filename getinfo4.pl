#!/usr/bin/perl -w
use strict;

my $path="D:\\perl\\file4\\file4\\*";
my @dir=glob($path);

foreach my $file (@dir)
{
  

my ($blast_out) = $file;
my $usage = "This script is to get the best hit from blast output file with 1 input sequence.
usage: $0 <blast_output_file>
";

open(BLASTOUT,$blast_out)||die("open $blast_out error!\n");
open(FILE, ">>igeminfo4.txt");

my $i=0;
my $j=0;
my $part_name = "--";
my $Uses = 0;
my $Twins = 0;
my @Stars = ();
my @Num = ();
my $avesta = 0;




while(<BLASTOUT>){
    chomp;
	if(/Part\:([\w\s]+)\:Experience/){
		$part_name=$1;
	}
	elsif(/line-height\:40\%;'\>([\&bul;]*)\<\/div\>$/){
		if($1 eq ''){
			$Stars[$i]=0;
		}else{
			@Num = split(/;/,$1);
			$Stars[$i]=$#Num+1;
		}
		$i++;
	}

	else{
	}
}

for($j=0; $j<$i; $j++){
	$avesta = $avesta + $Stars[$j];
}
if($i == 0){
	$avesta = -1;
}else{
	$avesta = $avesta/$i
}

print FILE $part_name,"|",$i,"|",sprintf("%.3f",$avesta),"\n";
close BLASTOUT;
close FILE;

}
exit;