#!/usr/bin/perl -w
use strict;

my $path="D:\\perl\\file1\\file1\\*";
my @dir=glob($path);

foreach my $file (@dir)
{
  

my ($blast_out) = $file;
my $usage = "This script is to get the best hit from blast output file with 1 input sequence.
usage: $0 <blast_output_file>
";

open(BLASTOUT,$blast_out)||die("open $blast_out error!\n");
open(FILE, ">>igeminfo1.txt");
my $name="";
my $type="";
my $desc="";
my $desi="";
my $len="";
my $i=0;


my $part_name = "--";
my $part_short_description = "--";
my $part_type = "--";
my $part_status = "--";
my $sample_status = "--";
my $part_results = "--";
my $part_nickname = "--";
my $part_rating = "--";
my $part_url = "--";
my $part_entered = "--";
my $part_author = "--";
my $Sequences = "--";
my $f1=0;


while(<BLASTOUT>){
    chomp;
	if(/^\s*\<part_name\>([\w]+)\<\/part_name\>/){
		if($f1 == 0){
			$part_name=$1;
			$f1 = 1;
		}
		elsif($f1 == 1){
			$f1 = 2;
		}
	}
	elsif(/^\s*\<part_short_desc\>(.+)\<\/part_short_desc\>$/){
		if($f1 == 1){
			$part_short_description=$1;
		}
	}
	elsif(/^\<part_type\>(.+)\<\/part_type\>$/){
		if($f1 == 1){
			$part_type=$1;
		}
	}
	elsif(/^\<release_status\>(.+)\<\/release_status\>$/){
		if($f1 == 1){
			$part_status=$1;
		}
	}
	elsif(/^\<sample_status\>(.+)\<\/sample_status\>$/){
		if($f1 == 1){
			$sample_status=$1;
		}
	}
	elsif(/^\<part_results\>(.+)\<\/part_results\>$/){
		if($f1 == 1){
			$part_results=$1;

		}
	}
	elsif(/^\<part_nickname\>(.+)\<\/part_nickname\>$/){
		if($f1 == 1){
			$part_nickname=$1;

		}
	}
	elsif(/^\<part_rating\>(.+)\<\/part_rating\>$/){
		if($f1 == 1){
			$part_rating=$1;

		}
	}
	elsif(/^\<part_url\>(.+)\<\/part_url\>$/){
		if($f1 == 1){
			$part_url=$1;
		}
	}
	elsif(/^\<part_entered\>(.+)\<\/part_entered\>$/){
		if($f1 == 1){
			$part_entered=$1;
		}
	}
	elsif(/^\<part_author\>(.+)\<\/part_author\>$/){
		if($f1 == 1){
			$part_author=$1;
		}
	}
	elsif(/^\<seq_data\>([atcg]+)/){
		if($f1 == 1){
			$Sequences=$1;
		}
	}
	else{
	}
}


print FILE $part_name,"|",$part_status,"|",$sample_status,"|",$part_results,"|",$part_rating,"|",$part_short_description,"\n";
close BLASTOUT;
close FILE;

}
exit;