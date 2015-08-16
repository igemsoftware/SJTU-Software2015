#!/usr/bin/perl -w
use strict;

my $path="D:\\perl\\file2\\file2\\*";
my @dir=glob($path);

foreach my $file (@dir)
{
  

my ($blast_out) = $file;
my $usage = "This script is to get the best hit from blast output file with 1 input sequence.
usage: $0 <blast_output_file>
";

open(BLASTOUT,$blast_out)||die("open $blast_out error!\n");
open(FILE, ">>igeminfo2.txt");
my $name="";
my $type="";
my $desc="";
my $desi="";
my $len="";
my $i=0;

my $part_name = "--";
my $Uses = 0;
my $Twins = 0;
my $DNA_status = "--";	
my $Qualitative_experience = "--";	
my $Group_favorite = "--";	
my $Star_rating = 0;	
my $Delete = "--";
my $Group = "--";




while(<BLASTOUT>){
    chomp;
	if(/Part\:([\w]+)\:Hard\s*Information/){
		$part_name=$1;
	}
	elsif(/\>([0-9]+)\s*Uses\<\/a\>\<\/div\>$/){
		$Uses=$1;
	}
	elsif(/\>([0-9]+)\s*Twins\<\/a\>\<\/div\>$/){
		$Twins=$1;
	}
	elsif(/DNA\s*Status\<TD\>([\s\w\;]+)\<TD\>\<\/TABLE\>/){
		$DNA_status=$1;
	}
	elsif(/Qualitative\s*Experience\<TD\s*style='width\:150px;'\>([\s\w\;]+)\<TD\>/){
		$Qualitative_experience=$1;
	}
	elsif(/Group\s*Favorite\<TD\s*style='width\:150px;'\>([\w\s]+)\<TD/){
		$Group_favorite=$1;
	}
	elsif(/Star\s*Rating\<TD\s*style='width\:150px;'\>([\w]+)\<TD/){
		$Star_rating=$1;
	}
	elsif(/Delete\s*This\s*Part\<TD\s*style='width\:150px;'\>([\w\s]+)\<TD/){
		$Delete=$1;
	}
	elsif(/\&nbsp;\s*Group\:\s*(['\w\s]+)\s*\&nbsp;/){
		$Group=$1;
	}
	else{
	}
}


print FILE $part_name,"|",$Uses,"|",$DNA_status,"|",$Qualitative_experience,"|",$Group_favorite,"|",$Star_rating,"|",$Delete,"|",$Group,"\n";
close BLASTOUT;
close FILE;

}
exit;