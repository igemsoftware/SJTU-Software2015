#!/usr/bin/perl -w
use strict;



my ($stan) = $ARGV[0];
my $usage = "This script is to get the best hit from blast output file with 1 input sequence.
usage: $0 <blast_output_file>
";

open(STAN,$stan)||die("open $stan error!\n");
open(FILE, ">igeminfo.txt");
open(SEQU, ">sequence.txt");

my $name="";
my $type="";
my $desc="";
my $desi="";
my $len="";



my $part_name = "--";
my $part_short_description = "--";
my $part_enter = "--";
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


my $Uses = 0;
my $Twins = 0;
my $DNA_status = "--";	
my $Qualitative_experience = "--";	
my $Group_favorite = "--";	
my $Star_rating = 0;	
my $Delete = "--";
my $Group = "--";
my $subparts = 1;
my $String = "";

my $location = 0;
my $address = "--";

my $i=0;
my $j=0;
my @Stars = ();
my @Num = ();
my $avesta = 0;


while(<STAN>){
chomp;
$part_name = $_;
my ($file1) = "part.cgi?part=".$_;
my ($file2) = "part_info.cgi?part_name=".$_;
my ($file3) = "get_part.cgi?part=".$_;
my ($file4) = "Part:".$_.":Experience";

if(open(FILE1,$file1)){
	$part_short_description = "--";
	$part_enter = "--";
	$part_type = "--";
	$part_status = "--";
	$sample_status = "--";
	$part_results = "--";
	$part_nickname = "--";
	$part_rating = "--";
	$part_url = "--";
	$part_entered = "--";
	$part_author = "--";
	$Sequences = "--";
	$f1=0;
	while(<FILE1>){
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
			$part_enter=$1;
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


print FILE $part_name,"|",$part_author,"|",$part_enter,"|",$part_type,"|",$part_status,"|",$sample_status,"|",$part_results,"|",$part_rating,"|",$part_short_description,"|";
close FILE1;


}else{
print FILE $part_name,"|","--","|","--","|","--","|","--","|","--","|","--","|","--","|","--","|";
}


if(open(FILE2,$file2)){
	$Uses = 0;
	$Twins = 0;
	$DNA_status = "--";	
	$Qualitative_experience = "--";	
	$Group_favorite = "--";	
	$Star_rating = 0;	
	$Delete = "--";
	$Group = "--";
	$subparts = 1;
	$String = "";
	while(<FILE2>){
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
	elsif(/var\s*subParts\s*=\s*null/){
		$subparts = 0;
	}
	elsif(/new\s*String\('([atcg]+)'\)/){
		$String = $1;
	}
	else{
	}
}


print FILE $Uses,"|",$DNA_status,"|",$Qualitative_experience,"|",$Group_favorite,"|",$Star_rating,"|",$Delete,"|",$Group,"|",$subparts,"|";
print SEQU ">",$part_name,"\n",$String,"\n","\n";
close FILE2;

}else{
print FILE "--","|","--","|","--","|","--","|","--","|","--","|","--","|","--","|";
}


if(open(FILE3,$file3)){
	$location = 0;
	$address = "--";
	while(<FILE3>){
    chomp;
	if(/content='Part\:([\w]+)\:/){
		$part_name = $1;
	}
	if(/Show\s*details\s*for\s*([0-9]+)\s*locations/){
		$location = $1;
	}

	else{
	}
}


if($part_name eq "--"){
}else{
print FILE $location,"|";
}


close FILE3;

}else{
print FILE $location,"|";
}


if(open(FILE4,$file4)){
	$i=0;
	$j=0;
	@Stars = ();
	@Num = ();
	$avesta = 0;
	while(<FILE4>){
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

print FILE $i,"|",sprintf("%.3f",$avesta),"\n";

close FILE4;

}else{
print FILE "0|",sprintf("%.3f",$avesta),"\n";
}
}

close FILE;
close SEQU;
exit;