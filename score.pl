#!/usr/bin/perl -w
use strict;


sub gscore{
	my($Part_status,$Sample_status,$Part_results,$Uses,$DNA_status,$Qualitative_experience,$Group_favorite,$Star_rating,$Del,$Groups,$Number_comments,$Ave_rating) = @_;
	my $score = 0.0;
	if($Part_status eq "Released HQ 2013" ){
		$score = $score + 1*10;
	}
	if($Sample_status eq "For reference only"){
		$score = $score + 1*10;
	}elsif($Sample_status eq "For reference only"){
		$score = $score + 0.5*10;
	}elsif($Sample_status eq "It&apos;s complicate"){
		$score = $score + 0.25*10;
	}else{}
	if($Part_results eq "Works" ){
		$score = $score + 1*15;
	}elsif($Part_results eq "Issues"){
		$score = $score + 0.25*15;
	}else{}
	$score = $score + $Uses*15/2935;
	if($DNA_status eq "Available" ){
		$score = $score + 1*10;
	}else{}
	if($Qualitative_experience eq "Works" ){
		$score = $score + 1*5;
	}elsif($Qualitative_experience eq "Issues" ){
		$score = $score +  0.25*5;
	}else{}
	if($Star_rating == 1 ){
		$score = $score + 1*10;
	}
	$score = $score + $Number_comments*10/10;
	if($Ave_rating == 0.0 || $Ave_rating == -1.0 ){
		$score = $score;
	}else{
		$score = $score + $Ave_rating*20/5;
	}
	return $score;
}


my ($input_file) = $ARGV[0];
my $usage = "This script is to get the information from blast output file with 1 input sequence.
usage: $0 <blast_output_file> <info_file>
";
die $usage if $#ARGV<0;

open(BLASTOUT,$input_file)||die("open $input_file error!\n");
open(FILE1, ">Combine_v4.txt");


my $i = 0;
my $j = 0;
my $Com_id = ""; 
my $Author = ""; 
my $Enter_time  = ""; 
my $Ctype  = ""; 
my $Part_status  = ""; 
my $Sample_status = ""; 
my $Part_results  = ""; 
my $Uses = 0;
my $DNA_status  = "";  
my $Qualitative_experience  = ""; 
my $Group_favorite  = ""; 
my $Star_rating = 0;
my $Del  = ""; 
my $Groups  = ""; 
my $Number_comments = 0;
my $Ave_rating = 0;
my $Des = ""; 
my @str = ();
my $Score = 0;

while(<BLASTOUT>){
    chomp;
	@str = split(/\|/, $_);
    $Score = gscore(@str[4..15]);
	for($i=0; $i<=$#str; $i++){
		print FILE1 $str[$i],"|";
	}
	print FILE1 sprintf "%.2f\n",$Score,"\n";
}



close BLASTOUT;
close FILE1;

exit;