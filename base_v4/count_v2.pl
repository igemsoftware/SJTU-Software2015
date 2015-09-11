#!/usr/bin/perl

use DBI;

sub gscore{
	my($Part_status,$Sample_status,$Part_results,$Star_rating,$Uses,$DNA_status,$Qualitative_experience,$Group_favorite,$Del,$Groups,$Confirmed_times,$Number_comments,$Ave_rating) = @_;
	my $score = 0.0;
	if($Part_status eq "Released HQ 2013" ){
		$score = $score + 1*7.5;
	}
	if($Sample_status eq "In Stock"){
		$score = $score + 1*6.8;
	}elsif($Sample_status eq "It’s complicated"){
		$score = $score + 0.5*6.8;
	}elsif($Sample_status eq "For Reference Only"){
		$score = $score + 0.25*6.8;
	}else{}
	if($Part_results eq "Works" ){
		$score = $score + 1*11.9;
	}elsif($Part_results eq "Issues"){
		$score = $score + 0.25*11.9;
	}else{}
	$score = $score + $Uses*13.7/2935;
	if($DNA_status eq "Available" ){
		$score = $score + 1*6.7;
	}else{}
	if($Qualitative_experience eq "Works" ){
		$score = $score + 1*3.5;
	}elsif($Qualitative_experience eq "Issues" ){
		$score = $score +  0.25*3.5;
	}else{}
	if($Group_favorite eq "Yes" ){
		$score = $score + 1*2.7;
	}else{}
	if($Star_rating == 1 ){
		$score = $score + 1*7.5;
	}
	$score = $score + $Confirmed_times*10/536;
	$score = $score + $Number_comments*10.5/10;
	if($Ave_rating == 0.0 || $Ave_rating == -1.0 ){
		$score = $score;
	}else{
		$score = $score + $Ave_rating*13.7/5;
	}
	if($Del eq "Not Deleted" ){
		$score = $score + 1*5.5;
	}else{}
	return $score;
}

# parameters
my $host = "localhost";
my $dbname = "base";
my $username = "root";
my $password = "huangwenze";

my $object = $ARGV[0];
my $type = $ARGV[1];
my $i=0;
my @brickid=();
my @score=();
my @unis=();
my $j=0.0;       
my $dbh = DBI->connect("DBI:mysql:database=$dbname;host=$host", "$username", "$password") || die "connection failed: ". DBI->errstr;

# execute INSERT query using do()
# my $rows = $dbh->do("INSERT INTO user (Host, User) VALUES ('localhost', 'xiongyitest1215')");

# execute SELECT query
print "the $type your want to know is $object\n";
if($type eq "brick"){
    my $sth1 = $dbh->prepare("SELECT Bri_id,Author,Enter_time,Btype,Uses,Des,Score FROM brick where (Bri_id like '%".$object."%') or (Btype like '%".$object."%') or (Des like '%".$object."%')");
    $sth1->execute();
	print "<\n";
	while(my $Meta = $sth1->fetchrow_hashref()) {
		@brickid = (@brickid,[$Meta->{'Bri_id'},$Meta->{'Score'},$Meta->{'Author'},$Meta->{'Enter_time'},$Meta->{'Btype'},$Meta->{'Uses'},$Meta->{'Des'}]);
		$i=$i+1;
	}
	@brickid = sort{$a->[1] <=> $b->[1]}@brickid;
	for($j=$#brickid; $j>=0; $j--){
		if($brickid[$j][1] < 45){
			last;
		}
		print $brickid[$j][0],"|",$brickid[$j][4],"|",$brickid[$j][6],"|",$brickid[$j][2],"|",$brickid[$j][3],"|",sprintf "%.2f\n",$brickid[$j][1];	
	}
	print ">\n";
}elsif($type eq "devic"){
    my $sth1 = $dbh->prepare("SELECT Com_id,Author,Enter_time,Ctype,Uses,Des,Score FROM combine where (Com_id like '%".$object."%') or (Ctype like '%".$object."%') or (Des like '%".$object."%')");
    $sth1->execute();
	print "<\n";
	while(my $Meta = $sth1->fetchrow_hashref()) {
		@brickid = (@brickid,[$Meta->{'Com_id'},$Meta->{'Score'},$Meta->{'Author'},$Meta->{'Enter_time'},$Meta->{'Ctype'},$Meta->{'Uses'},$Meta->{'Des'}]);
		$i=$i+1;
	}
	@brickid = sort{$a->[1] <=> $b->[1]}@brickid;
	for($j=$#brickid; $j>=0; $j--){
		if($brickid[$j][1] < 45){
			last;
		}
		print $brickid[$j][0],"|",$brickid[$j][4],"|",$brickid[$j][6],"|",$brickid[$j][2],"|",$brickid[$j][3],"|",sprintf "%.2f\n",$brickid[$j][1];		
	}
	print ">\n";
}

# clean up
$dbh->disconnect();
    exit(0);

