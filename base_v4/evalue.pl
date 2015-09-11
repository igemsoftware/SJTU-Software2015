#!/usr/bin/perl -w
use strict;


#input,split by |
my ($device) = $ARGV[0];
my ($description) = $ARGV[1];
my @part=split(/\*/,$device); 
my @function=split(/\*/,$description); 

use DBI;

# database parameters
my $host = "localhost";
my $dbname = "base";
my $username = "root";
my $password = "";

my $i = 0;
my $j = 0;
my $count_part = 0;#count of the score of each part
my $count_influence = 0;  #count of the score of influence
my $each_part_score = 0;  # sum of scores of each part
my $influence_part_score = 0;# sum of scores of influence part
my $total_score = 0;
my %part_sorce;  #part_name-->part_socre
my %part_desc; #part_name-->part_type(Coding/../..)
my %desc;#part_name-->if it is function(1 or 0)

my $dbh = DBI->connect("DBI:mysql:database=$dbname;host=$host", "$username", "$password") || die "connection failed: ". DBI->errstr;
for($i = 0;$i <= $#part; $i = $i + 1){
	my $sth_1 = $dbh->prepare("(SELECT Bri_id,Btype,Score FROM brick where Bri_id like '%".$part[$i]."%')");
	$sth_1->execute();
	while(my $ref = $sth_1->fetchrow_hashref()){
		$part_sorce{$ref->{'Bri_id'}} = $ref->{'Score'};
		$part_desc{$ref->{'Bri_id'}} = $ref->{'Btype'};
	}
}
while(my($k,$v)=each%part_sorce){
	$each_part_score = $each_part_score + $v;
	$count_part = $count_part + 1;
}
while(my($k,$v)=each%part_desc){
	if($v =~ /Coding/){
		$desc{$k} = 1;
	}else{
		$desc{$k} = 0;
	}
}
$total_score = gscore($device,$description);
#optimization
my %id_des; #input_id-->input_des
my %opt;#the result of opt
my $count_best = 0;
my $opt_result = "";
for($i = 0;$i <= $#part; $i = $i + 1){
	$id_des{$part[$i]} = $function[$i];
}
for($i = 0;$i <= $#part; $i = $i + 1){
	if($desc{$part[$i]} == 1){
		my $sth_3 = $dbh->prepare("(SELECT Bri_id FROM brick where Des likes '%".$function[$i]."%' order by Score)");
		$sth_3->execute();
		while(my $ref_3 = $sth_3->fetchrow_hashref()){
			if($count_best < 10){
				if($count_best == 0){
					$opt_result = $ref_3->{'Bri_id'};
				}else{
					$opt_result = $opt_result.'|'.$ref_3->{'Bri_id'};
				}
			}
		}
		$opt{$part[$i]} = $opt_result;
		$opt_result = "";
		$count_best = 0;
	}
}

$opt_result = "";
for($i = 0;$i <= $#part; $i = $i + 1){
	if($desc{$part[$i]} == 0){
		$j = 0;
		my $sth_4 = $dbh->prepare("(SELECT Bri_id FROM brick where Btype likes '%".$part_desc{$part[$i]}."%')");
		$sth_4->execute();
		my %opt_score; #the replace part-->new device score
		while(my $ref_4 = $sth_4->fetchrow_hashref()){
			my $new_device = "";
			%opt_score =();
			for($j = 0;$j <= $#part; $j = $j + 1){
				if(($j == 0) and ($i != $j)){
					$new_device = $part[$j];
				}
				if(($j == 0) and ($i == $j)){
					$new_device = $ref_4->{'Bri_id'};
				}
				if(($j != 0) and ($i != $j)){
					$new_device = $new_device.'|'.$part[$j];
				}
				if(($j != 0) and ($i == $j)){
					$new_device = $new_device.'|'.$ref_4->{'Bri_id'};
				}
			}
			$opt_score{$ref_4->{'Bri_id'}} = gscore($new_device);
		}
		my @score_sort = sort {$opt_score{$b}<=>$opt_score{$a}} keys %opt_score;
		for($j = 0;$j < 10; $j = $j + 1){
			if($j == 0){
				$opt_result = $score_sort[$j];
			}else{
				$opt_result = $opt_result.'|'.$score_sort[$j];
			}
		}
		$opt{$part[$i]} = $opt_result;
		$opt_result = "";
	}
}
						
print "$total_score\n";
for($i = 0;$i <= $#part; $i = $i + 1){
	print "$part[$i]\t$opt{$part[$i]}\n";
}

# clean up
$dbh->disconnect();
    exit(0);


	
sub gscore{
	my($Device) = @_;
	my @part=split(/\|/,$Device); 

	use DBI;

	# database parameters
	my $host = "localhost";
	my $dbname = "base";
	my $username = "root";
	my $password = "";
	my $score = 0.0;

	my $i = 0;
	my $j = 0;
	my $count_part = 0;#count of the score of each part
	my $count_influence = 0;  #count of the score of influence
	my $each_part_score = 0;  # sum of scores of each part
	my $influence_part_score = 0;# sum of scores of influence part
	my $total_score = 0;
	my %part_sorce;  #part_name-->part_socre
	my %part_desc; #part_name-->part_type(Coding/../..)
	my %desc;#part_name-->if it is function(1 or 0)
	my %combine_score;#divice_name-->score

	my $dbh = DBI->connect("DBI:mysql:database=$dbname;host=$host", "$username", "$password") || die "connection failed: ". DBI->errstr;
	for($i = 0;$i <= $#part; $i = $i + 1){
		my $sth_1 = $dbh->prepare("(SELECT Bri_id,Btype,Score FROM brick where Bri_id like '%".$part[$i]."%')");
		$sth_1->execute();
		while(my $ref = $sth_1->fetchrow_hashref()){
			$part_sorce{$ref->{'Bri_id'}} = $ref->{'Score'};
			$part_desc{$ref->{'Bri_id'}} = $ref->{'Btype'};
		}
	}
	while(my($k,$v)=each%part_sorce){
		$each_part_score = $each_part_score + $v;
		$count_part = $count_part + 1;
	}
	while(my($k,$v)=each%part_desc){
		if($v =~ /Coding/){
			$desc{$k} = 1;
		}else{
			$desc{$k} = 0;
		}
	}

	for($i = 0;$i <= $#part; $i = $i + 1){
		if($desc{$part[$i]} == 1){
			for($j = 0;$j <= $#part; $j = $j + 1){
				if($j != $i){	
					my $sth_2 = $dbh->prepare("(SELECT S.Com_id,R.Score FROM (contain as S join contain as T on S.Com_id = T.Com_id) join combine as R on S.Com_id = R.Com_id, where (S.Bri_id likes '%".$part[$i]."%') and (T.Bri_id likes '%".$part[$j]."%'))");
					$sth_2->execute();
					while(my $ref_2 = $sth_2->fetchrow_hashref()){
						$combine_score{$ref_2->{'Com_id'}} = $ref_2->{'Score'};
						$influence_part_score = $influence_part_score + $ref_2->{'Score'};
						$count_influence = $count_influence + 1;
					}
				}
			}
		}
	}

	$total_score = (0.65 * $each_part_score / $count_part) + (0.35 * $influence_part_score / $count_influence); 
	return $$total_score;
}
