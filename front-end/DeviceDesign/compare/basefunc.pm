#!/usr/bin/perl

package basefunc;
require Exporter;  
@ISA = qw(Exporter);
@EXPORT = qw(evaluate_score evaluate);
@EXPORT_OK = qw(); 

sub evaluate_score{
	my($Device) = @_;
	my @part=split(/,/,$Device); 
	
	use DBI;

	# database parameters
	my $host = "localhost";
	my $dbname = "base";
	my $username = "root";
	my $password = "";
	my $score = 0.0;
	my $i = 0;
	my $j = 0;
	my $count_part_coding = 0;#count of the score of each part which is coding
	my $count_part_noncoding = 0;#count of the score of each part which is not coding
	my $count_influence = 0;  #count of the score of influence
	my $each_part_coding_score = 0;  # sum of scores of each part which is coding
	my $each_part_noncoding_score = 0;  # sum of scores of each part which is not coding
	my $influence_part_score = 0;# sum of scores of influence part
	my $total_score = 0;
	my $reporter = 0;
	my %part_sorce;  #part_name-->part_socre
	my %part_desc; #part_name-->part_type(Coding/../..)
	my %desc;#part_name-->if its type is coding(1 or 0)
	my %combine_score;#divice_name-->score
	
	#connect the database with mysql
	my $dbh = DBI->connect("DBI:mysql:database=$dbname;host=$host", "$username", "$password") || die "connection failed: ". DBI->errstr;
	for($i = 0;$i <= $#part; $i = $i + 1){
		my $sth_1 = $dbh->prepare("(SELECT Bri_id,Btype,Score FROM brick where Bri_id like '%".$part[$i]."%')");
		$sth_1->execute();
		while(my $ref = $sth_1->fetchrow_hashref()){
			#store the score of the biobrick
			$part_sorce{$ref->{'Bri_id'}} = $ref->{'Score'};
			#store the type of the biobrick
			$part_desc{$ref->{'Bri_id'}} = $ref->{'Btype'};
		}
	}
	
	#judge part whose type is coding and if there is a reporter,the score will be added 5
	while(my($k,$v)=each%part_desc){
		if($v =~ /Coding/){
			$desc{$k} = 1;
		}else{
			$desc{$k} = 0;
		}	
		if($v =~ /Reporter/){
			$reporter = $reporter + 1;
			if($reporter == 1){
			      $total_score = $total_score + 5;
			}
	    }
	}
	
	#calculate the sum of the part score and the number of part 
	while(my($k,$v)=each%part_sorce){
		if($desc{$k} == 1){
			#calculate the score of the part which is coding
			$each_part_coding_score = $each_part_coding_score + $v;
			$count_part_coding = $count_part_coding + 1;
		}elsif($desc{$k} == 0){
			#calculate the score of the part which is not coding
			$each_part_noncoding_score = $each_part_noncoding_score + $v;
			$count_part_noncoding = $count_part_noncoding + 1;
		}
	}
	
	#calculate the sum of the interence score of each two part
	for($i = 0;$i <= $#part; $i = $i + 1){
		if($desc{$part[$i]} == 1){
			for($j = 0;$j <= $#part; $j = $j + 1){
				if($j != $i){	
					my $sth_2 = $dbh->prepare("(SELECT tolscore,unzore,tolnum FROM conscore where ((Bri_id1 like '%".$part[$i]."%') and (Bri_id2 like '%".$part[$j]."%')) or ((Bri_id2 like '%".$part[$i]."%') and (Bri_id1 like '%".$part[$j]."%')))");
					$sth_2->execute();
					while(my $ref_2 = $sth_2->fetchrow_hashref()){
						if($ref_2->{'tolscore'} eq ""){$ref_2->{'tolscore'} = 0;}
						if($ref_2->{'unzore'} eq ""){$ref_2->{'unzore'} = 1;}
						if($ref_2->{'tolnum'} eq ""){$ref_2->{'tolnum'} = 1;}
						$influence_part_score = $influence_part_score + 0.65 * $ref_2->{'tolscore'} / $ref_2->{'unzore'} + 0.35 * $ref_2->{'tolscore'} / $ref_2->{'tolnum'};
						$count_influence = $count_influence + 1;
					}
				}
			}
		}
	}
	#calculate the device score that is the sum of the average of biobrick score * 0.8 and the average of biobrick interence score * 0.6
	if($count_influence ==0){$count_influence = 1};
	if($count_part_coding == 0){
		$total_score = (0.65 *  $each_part_noncoding_score / $count_part_noncoding) + (0.35 * $influence_part_score / $count_influence); 
	}else{
		$total_score = (0.65 * ((0.8 * $each_part_coding_score / $count_part_coding) + (0.2 * $each_part_noncoding_score / $count_part_noncoding))) + (0.35 * $influence_part_score / $count_influence); 
	}
	if($total_score <= 42){
		$total_score = 2**(1/2) * 185 / 4 - 10 * (37**2 /32 - $total_score)**(1/2);
	}else{
		$total_score = 10 *($total_score - 10)**(1/2);
	}
	#return the score of the device
	return $total_score;
}

sub evaluate{
	my($device,$description,$cutoff) = @_;
	my @part=split(/,/,$device); 
	my @function=split(/,/,$description); 
	my @keyword = ();
	my @key = ();
	my $i = 0;
	my $j = 0;
	#deal with the kry word with +
	for($i = 0;$i <= $#function;$i = $i + 1){
		@key = split(/\+/,$function[$i]);
		$keyword[$i] = "Des like ";
		for($j = 0;$j <= $#key;$j = $j + 1){
			if($j != $#key){
				$keyword[$i] = $keyword[$i]."'%".$key[$j]."%' or Des like ";
			}elsif($j == $#key){
				$keyword[$i] = $keyword[$i]."'%".$key[$j]."%'";
			}
		}
	}
	
	use DBI;
	
	# database parameters
	my $host = "localhost";
	my $dbname = "base";
	my $username = "root";
	my $password = "";
	my $completiton = -3;#the completiton of the device
	my $order = -3;#the order of the device
	my $order_flag = 0;#if the part is Inverter or Generator
	my $total_score = 0;
	my $reporter = 0;#if there is a reporter
	my %part_desc; #part_name-->part_type(Coding/../..)
	my %desc;#part_name-->if its type is coding(1 or 0)
	
	#connect the database with mysql
	my $dbh = DBI->connect("DBI:mysql:database=$dbname;host=$host", "$username", "$password") || die "connection failed: ". DBI->errstr;
	#store the type of the biobrick
	for($i = 0;$i <= $#part; $i = $i + 1){
		my $sth_1 = $dbh->prepare("(SELECT Bri_id,Btype,Score FROM brick where Bri_id like '%".$part[$i]."%')");
		$sth_1->execute();
		while(my $ref = $sth_1->fetchrow_hashref()){
			$part_desc{$ref->{'Bri_id'}} = $ref->{'Btype'};
		}
	}
	
	#if there is a biobrick whose type is Inverter or Generator,judge if the order of biobrick is current
	for($i = 0;$i <= $#part;$i = $i + 1){
		if(($order_flag == 1) and (!($part_desc{$part[$i]} =~ /Terminator/))){
			$order = -100;
		}
		if(($part_desc{$part[$i]} =~ /Inverter/) or ($part_desc{$part[$i]} =~ /Generator/)){
			$order_flag = 1;
			if($i != 0){
				$order = -100;
			}
		}
	}
	
	#if there is not a biobrick whose type is Inverter and Generator,judge if the order of biobrick is current
	if($order_flag == 0){
		if($part_desc{$part[$#part]} =~ /Terminator/){
			$order = $order + 1;
		}
		if($part_desc{$part[0]} =~ /Regulatory/){
			$order = $order + 1;
		}
	}
	
	#judge part whose type is coding and judge the completiton of the device
	while(my($k,$v)=each%part_desc){
		if($v =~ /Coding/){
			$desc{$k} = 1;
		}else{
			$desc{$k} = 0;
		}
		if($v =~ /Coding/){
			$completiton = $completiton + 1;
			$order = $order + 1;
		}
		if($v =~ /Regulatory/){
			$completiton = $completiton + 1;
		}
		if($v =~ /Terminator/){
			$completiton = $completiton + 1;
		}
		if($v =~ /Inverter/){
			$completiton = $completiton + 3;
		}
		if($v =~ /Generator/){
			$completiton = $completiton + 3;
		}
		#if there is a reporter,the score will be added 5
		if($v =~ /Reporter/){
			$reporter = $reporter + 1;
			if($reporter == 1){
				$total_score = $total_score + 5;
			}
		}
	}
	
	#if the device is complete,print 1
	#if the device is not complete,print 0
	if($completiton < 0){
		print "0\n";
	}else{
		print "1\n";
	}
	
	#if the device is ordered,print 1
	#if the device is not ordered,print 0
	if($order_flag == 1){
		if($order == -100){
			print "0\n";
		}else{
			print "1\n";
		}
	}elsif($order_flag == 0){
		if($order < 0){
			print "0\n";
		}else{
			print "1\n";
		}
	}
	#print the score of device	
	$total_score = $total_score + evaluate_score($device);
	print "$total_score\n";
	
	
	#evaluate
	my %id_des = (); #input_id-->input_des
	my %opt = ();#the result of opt
	my %opt_score = (); #the replace part-->new device score
	my @score_sort;
	my $count_best = 0;
	my $opt_result = "";
	my $new_device = "";
	
	for($i = 0;$i <= $#part; $i = $i + 1){
		$id_des{$part[$i]} = $function[$i];
	}
	
	#evaluate the best 10 part of the coding 
	for($i = 0;$i <= $#part; $i = $i + 1){
		if($desc{$part[$i]} == 1){
			my $sth_3;
			if($description =~ /,*/){
				$sth_3 = $dbh->prepare("(SELECT Bri_id FROM brick where Btype like '%".$part_desc{$part[$i]}."%' order by Score desc)");
			}else{
				$sth_3 = $dbh->prepare("(SELECT Bri_id FROM brick where Btype like '%".$part_desc{$part[$i]}."%' and ($keyword[$i]) order by Score desc)");
			}
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
	
	#evaluate the best 10 part of the non_coding
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
					$opt_score{$ref_4->{'Bri_id'}} = evaluate_score($new_device);
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
}

1;

