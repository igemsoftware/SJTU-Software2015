#!/usr/bin/perl -w
use strict;

#input,split by |
my ($device) = $ARGV[0];
my ($description) = $ARGV[1];
my ($cutoff) = $ARGV[2];
my @part=split(/,/,$device); 
my @function=split(/,/,$description); 

use DBI;

# database parameters
my $host = "localhost";
my $dbname = "base";
my $username = "root";
my $password = "superjjj2486";
my $completiton = -3;#the completiton of the device
my $i = 0;
my $j = 0;
my $count_part = 0;#count of the score of each part
my $count_influence = 0;  #count of the score of influence
my $each_part_score = 0;  # sum of scores of each part
my $influence_part_score = 0;# sum of scores of influence part
my $total_score = 0;
my $reporter = 0;#if there is a reporter
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
if($part_desc{$part[$#part]} =~ /Terminator/){
	$completiton = $completiton + 1;
}
if($part_desc{$part[0]} =~ /Regulatory/){
	$completiton = $completiton + 1;
}
while(my($k,$v)=each%part_desc){
	if($v =~ /Coding/){
		$desc{$k} = 1;
	}else{
		$desc{$k} = 0;
	}
	if($v =~ /Coding/ and $completiton >= -1){
		$completiton = $completiton + 1;
	}
	if($v =~ /Inverter/){
		$completiton = $completiton + 3;
	}
	if($v =~ /Generator/){
		$completiton = $completiton + 3;
	}
	if($v =~ /Reporter/){
		$reporter = $reporter + 1;
		if($reporter == 1){
			$total_score = $total_score + 5;
		}
	}
}
if($completiton < 0){
	print "0\n";
}else{
	print "1\n";
}

$total_score = $total_score + gscore($device,$description);
print "$total_score\n";


#optimization
my %id_des = (); #input_id-->input_des
my %opt = ();#the result of opt
my $count_best = 0;
my $opt_result = "";
my %opt_score = (); #the replace part-->new device score
my @score_sort;
my $new_device = "";
for($i = 0;$i <= $#part; $i = $i + 1){
	$id_des{$part[$i]} = $function[$i];
}

for($i = 0;$i <= $#part; $i = $i + 1){
	if($desc{$part[$i]} == 1){
		my $sth_3 = $dbh->prepare("(SELECT Bri_id FROM brick where Des like '%".$function[$i]."%' order by Score desc)");
		$sth_3->execute();
		while(my $ref_3 = $sth_3->fetchrow_hashref()){
			if($count_best <= 10){
				if($count_best == 0){
					$opt_result = $ref_3->{'Bri_id'};
				}else{
					$opt_result = $opt_result.','.$ref_3->{'Bri_id'};
				}
			}
			$count_best = $count_best + 1;
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
		%opt_score = ();
		$count_best = 0;
		my $sth_4 = $dbh->prepare("(SELECT Bri_id FROM brick where Btype like '%".$part_desc{$part[$i]}."%' order by Score desc)");
		$sth_4->execute();
		while(my $ref_4 = $sth_4->fetchrow_hashref()){
			if($count_best <= $cutoff){
				$new_device = ""; 
				for($j = 0;$j <= $#part; $j = $j + 1){
					if(($j == 0) and ($i != $j)){
						$new_device = $part[$j];
					}
					if(($j == 0) and ($i == $j)){
						$new_device = $ref_4->{'Bri_id'};
					}
					if(($j != 0) and ($i != $j)){
						$new_device = $new_device.','.$part[$j];
					}
					if(($j != 0) and ($i == $j)){
						$new_device = $new_device.','.$ref_4->{'Bri_id'};
					}
				}
				$opt_score{$ref_4->{'Bri_id'}} = gscore($new_device);
			}
			$count_best = $count_best + 1;
		}
		@score_sort = sort {$opt_score{$b}<=>$opt_score{$a}} keys %opt_score;
		for($j = 0;$j < $#score_sort; $j = $j + 1){
		     if($j < 10){
			if($j == 0){
				$opt_result = $score_sort[$j];
			}else{
				$opt_result = $opt_result.','.$score_sort[$j];

			}
		     }
		}

		$opt{$part[$i]} = $opt_result;
		$opt_result = "";
		@score_sort=();
	}
}

for($i = 0;$i <= $#part; $i = $i + 1){
	print "$part[$i]\t$opt{$part[$i]}\n";
}



# clean up
$dbh->disconnect();
    exit(0);


	
sub gscore{
	my($Device) = @_;
	my @part=split(/,/,$Device); 

	use DBI;

	# database parameters
	my $host = "localhost";
	my $dbname = "base";
	my $username = "root";
	my $password = "superjjj2486";
	my $score = 0.0;

	my $i = 0;
	my $j = 0;
	my $count_part = 0;#count of the score of each part
	my $count_influence = 0;  #count of the score of influence
	my $each_part_score = 0;  # sum of scores of each part
	my $influence_part_score = 0;# sum of scores of influence part
	my $total_score = 0;
	my $completiton = -3;#the completiton of the device
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
	if($part_desc{$part[$#part]} =~ /Terminator/){
		$completiton = $completiton + 1;
	}
	if($part_desc{$part[0]} =~ /Regulatory/){
		$completiton = $completiton + 1;
	}
	while(my($k,$v)=each%part_desc){
		if($v =~ /Coding/){
			$desc{$k} = 1;
		}else{
			$desc{$k} = 0;
		}	
		if($v =~ /Coding/ and $completiton >= -1){
			$completiton = $completiton + 1;
		}

		if($v =~ /Inverter/){
			$completiton = $completiton + 3;
		}
		if($v =~ /Generator/){
			$completiton = $completiton + 3;
		}
		if($v =~ /Reporter/){
			$reporter = $reporter + 1;
			if($reporter == 1){
			      $total_score = $total_score + 5;
			}
	        }
	}
	for($i = 0;$i <= $#part; $i = $i + 1){
		if($desc{$part[$i]} == 1){
			for($j = 0;$j <= $#part; $j = $j + 1){
				if($j != $i){	
					my $sth_2 = $dbh->prepare("(SELECT tolscore,unzore,tolnum FROM conscore where ((Bri_id1 like '%".$part[$i]."%') and (Bri_id2 like '%".$part[$j]."%')) or ((Bri_id2 like '%".$part[$i]."%') and (Bri_id1 like '%".$part[$j]."%')))");
					$sth_2->execute();
					while(my $ref_2 = $sth_2->fetchrow_hashref()){
						if($ref_2->{'tolscore'} == ""){$ref_2->{'tolscore'} = 0;}
						if($ref_2->{'unzore'} == ""){$ref_2->{'unzore'} = 1;}
						if($ref_2->{'tolnum'} == ""){$ref_2->{'tolnum'} = 1;}
						$influence_part_score = $influence_part_score + 0.65 * $ref_2->{'tolscore'} / $ref_2->{'unzore'} + 0.35 * $ref_2->{'tolscore'} / $ref_2->{'tolnum'};
						$count_influence = $count_influence + 1;
					}
				}
			}
		}
	}
	if($count_influence ==0){$count_influence = 1};
	$total_score = (0.65 * $each_part_score / $count_part) + (0.35 * $influence_part_score / $count_influence); 
	return $total_score;
}
