#!/usr/bin/perl

use DBI;

sub gscore{
	my($Part_status,$Sample_status,$Part_results,$Star_rating,$Uses,$DNA_status,$Qualitative_experience,$Group_favorite,$Del,$Groups,$Confirmed_times,$Number_comments,$Ave_rating,$Power) = @_;
	my @Pow = split(/\*/,$Power);
	my @ss = ();
	my $i = 0;
	my $sscore = "";
	for($i=0; $i<=$#Pow; $i++){
		$ss[$i] = 0.0;
	}
	my $score = 0.0;
	if($Part_status eq "Released HQ 2013" ){
		$score = $score + 1*$Pow[0];
		$ss[0] =  sprintf "%0.2f",1*$Pow[0];
	}
	if($Sample_status eq "In Stock"){
		$score = $score + 1*$Pow[1];
		$ss[1] = sprintf "%0.2f",1*$Pow[1];
	}elsif($Sample_status eq "It’s complicated"){
		$score = $score + 0.5*$Pow[1];
		$ss[1] = sprintf "%0.2f",0.5*$Pow[1];
	}elsif($Sample_status eq "For Reference Only"){
		$score = $score + 0.25*$Pow[1];
		$ss[1] = sprintf "%0.2f",0.25*$Pow[1];
	}else{}
	if($Part_results eq "Works" ){
		$score = $score + 1*$Pow[2];
		$ss[2] = sprintf "%0.2f",1*$Pow[2];
	}elsif($Part_results eq "Issues"){
		$score = $score + 0.25*$Pow[2];
		$ss[2] = sprintf "%0.2f",0.25*$Pow[2];
	}else{}
	if($Star_rating == 1 ){
		$score = $score + 1*$Pow[3];
		$ss[3] = sprintf "%0.2f",1*$Pow[3];
	}
	$score = $score + $Uses*$Pow[4]/2935;
	$ss[4] = sprintf "%0.2f",$Uses*$Pow[4]/2935;
	if($DNA_status eq "Available" ){
		$score = $score + 1*$Pow[5];
		$ss[5] = sprintf "%0.2f",1*$Pow[5];
	}else{}
	if($Qualitative_experience eq "Works" ){
		$score = $score + 1*$Pow[6];
		$ss[6] = sprintf "%0.2f",1*$Pow[6];
	}elsif($Qualitative_experience eq "Issues" ){
		$score = $score +  0.25*$Pow[6];
		$ss[6] = sprintf "%0.2f",0.25*$Pow[6];
	}else{}
	if($Group_favorite eq "Yes" ){
		$score = $score + 1*$Pow[7];
		$ss[7] = sprintf "%0.2f",1*$Pow[7];
	}else{}
	if($Del eq "Not Deleted" ){
		$score = $score + 1*$Pow[8];
		$ss[8] = sprintf "%0.2f",1*$Pow[8];
	}else{}
	$score = $score + $Confirmed_times*$Pow[9]/536;
	$ss[9] = sprintf "%0.2f",$Confirmed_times*$Pow[9]/536;
	$score = $score + $Number_comments*$Pow[10]/10;
	$ss[10] = sprintf "%0.2f",$Number_comments*$Pow[10]/10;
	if($Ave_rating == 0.0 || $Ave_rating == -1.0 ){
		$score = $score;
	}else{
		$score = $score + $Ave_rating*$Pow[11]/5;
		$ss[11] = sprintf "%0.2f",$Ave_rating*$Pow[11]/5;
	}
	$sscore = $ss[0];
	for($i=1; $i<=$#ss; $i++){
		$sscore = $sscore."|".$ss[$i];
	}
	return $score,$sscore;
}

# parameters
my $host = "localhost";
my $dbname = "base";
my $username = "root";
my $password = "huangwenze";

my $object = $ARGV[0];
my $type = $ARGV[1];
my $hPower = $ARGV[2];
my $limit = $ARGV[3];
my $i=0;
my @obj = ();
@obj = split(/\*/,$object);
print @obj,$#obj,"\n";
my @brickid=();
my @score=();
my @unis=();
my $r=0;
my $j=0.0;       
my $dbh = DBI->connect("DBI:mysql:database=$dbname;host=$host", "$username", "$password") || die "connection failed: ". DBI->errstr;

# execute INSERT query using do()
# my $rows = $dbh->do("INSERT INTO user (Host, User) VALUES ('localhost', 'xiongyitest1215')");

# execute SELECT query
print "the $type your want to know is $object\n";
if($type eq "brick"){
    my $string = "SELECT Bri_id,Author,Enter_time,Btype,Part_status,Sample_status,Part_results,Star_rating,Uses,DNA_status,Qualitative_experience,Group_favorite,Del,Groups,Confirmed_times,Number_comments,Ave_rating,Des FROM brick where (Bri_id like '%".$obj[0]."%') or (Btype like '%".$obj[0]."%') or (Des like '%".$obj[0]."%')";
	for($r=1;$r<=$#obj;$r++){
		$string = $string."or (Bri_id like '%".$obj[$r]."%') or (Btype like '%".$obj[$r]."%') or (Des like '%".$obj[$r]."%')";
	}
	my $sth1 = $dbh->prepare($string);
	$sth1->execute();
	while(my $Meta = $sth1->fetchrow_hashref()) {
		@score=gscore($Meta->{'Part_status'},$Meta->{'Sample_status'},$Meta->{'Part_results'},$Meta->{'Star_rating'},$Meta->{'Uses'},$Meta->{'DNA_status'},$Meta->{'Qualitative_experience'},$Meta->{'Group_favorite'},$Meta->{'Del'},$Meta->{'Groups'},$Meta->{'Confirmed_times'},$Meta->{'Number_comments'},$Meta->{'Ave_rating'},$hPower);
		@brickid = (@brickid,[$Meta->{'Bri_id'},$score[0],$Meta->{'Author'},$Meta->{'Enter_time'},$Meta->{'Btype'},$Meta->{'Uses'},$Meta->{'Des'},$score[1]]);
		$i=$i+1;
	}
	@brickid = sort{$a->[1] <=> $b->[1]}@brickid;
	for($j=$#brickid; $j>=0; $j--){
		if($brickid[$j][1] < $limit ){
			last;
		}
		print $brickid[$j][0],"|",$brickid[$j][4],"|",$brickid[$j][6],"|",$brickid[$j][2],"|",$brickid[$j][3],"|",sprintf "%.2f\n",$brickid[$j][1];	
		print $brickid[$j][7],"\n";
	}
	print ">\n";
}elsif($type eq "devic"){
    my $string = "SELECT Com_id,Author,Enter_time,Ctype,Part_status,Sample_status,Part_results,Star_rating,Uses,DNA_status,Qualitative_experience,Group_favorite,Del,Groups,Confirmed_times,Number_comments,Ave_rating,Des FROM combine where (Com_id like '%".$obj[0]."%') or (Ctype like '%".$obj[0]."%') or (Des like '%".$obj[0]."%')";
	for($r=1;$r<=$#obj;$r++){
		$string = $string."or (Com_id like '%".$obj[$r]."%') or (Ctype like '%".$obj[$r]."%') or (Des like '%".$obj[$r]."%')";
	}
	my $sth1 = $dbh->prepare($string);
	$sth1->execute();
	while(my $Meta = $sth1->fetchrow_hashref()) {
		@brickid = (@brickid,[$Meta->{'Com_id'},gscore($Meta->{'Part_status'},$Meta->{'Sample_status'},$Meta->{'Part_results'},$Meta->{'Star_rating'},$Meta->{'Uses'},$Meta->{'DNA_status'},$Meta->{'Qualitative_experience'},$Meta->{'Group_favorite'},$Meta->{'Del'},$Meta->{'Groups'},$Meta->{'Confirmed_times'},$Meta->{'Number_comments'},$Meta->{'Ave_rating'},$hPower),$Meta->{'Author'},$Meta->{'Enter_time'},$Meta->{'Ctype'},$Meta->{'Uses'},$Meta->{'Des'}]);
		$i=$i+1;
	}
	@brickid = sort{$a->[1] <=> $b->[1]}@brickid;
	for($j=$#brickid; $j>=0; $j--){
		if($brickid[$j][1] < $limit ){
			last;
		}
		print $brickid[$j][0],"|",$brickid[$j][4],"|",$brickid[$j][6],"|",$brickid[$j][2],"|",$brickid[$j][3],"|",sprintf "%.2f\n",$brickid[$j][1];		
	}
	print ">\n";
}

# clean up
$dbh->disconnect();
    exit(0);