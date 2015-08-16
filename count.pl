#!/usr/bin/perl

use DBI;

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
    my $sth1 = $dbh->prepare("SELECT Bri_id,Btype,Part_status,Sample_status,Part_results,Uses,DNA_status,Qualitative_experience,Group_favorite,Star_rating,Del,Groups,Number_comments,Ave_rating,Des FROM brick where (Bri_id like '%".$object."%') or (Btype like '%".$object."%') or (Des like '%".$object."%')");
    $sth1->execute();
	print "<\n";
	while(my $Meta = $sth1->fetchrow_hashref()) {
		$j = gscore($Meta->{'Part_status'},$Meta->{'Sample_status'},$Meta->{'Part_results'},$Meta->{'Uses'},$Meta->{'DNA_status'},$Meta->{'Qualitative_experience'},$Meta->{'Group_favorite'},$Meta->{'Star_rating'},$Meta->{'Del'},$Meta->{'Groups'},$Meta->{'Number_comments'},$Meta->{'Ave_rating'});
		@brickid = (@brickid,[$Meta->{'Bri_id'},$j]);
		$i=$i+1;
	}
	@brickid = sort{$a->[1] <=> $b->[1]}@brickid;
	for($j=$#brickid; $j>=0; $j--){
		if($brickid[$j][1] < 70){
			last;
		}
		print $brickid[$j][0],"\t",sprintf "%.2f\n",$brickid[$j][1];	
	}
	print ">\n";
}elsif($type eq "devic"){
    my $sth2 = $dbh->prepare("SELECT Com_id,Ctype,Part_status,Sample_status,Part_results,Uses,DNA_status,Qualitative_experience,Group_favorite,Star_rating,Del,Groups,Number_comments,Ave_rating,Des FROM combine where (Com_id like '%".$object."%') or (Ctype like '%".$object."%') or (Des like '%".$object."%')");
    $sth2->execute();
	print "<\n";
	while(my $Meta = $sth2->fetchrow_hashref()) {
		$j = gscore($Meta->{'Part_status'},$Meta->{'Sample_status'},$Meta->{'Part_results'},$Meta->{'Uses'},$Meta->{'DNA_status'},$Meta->{'Qualitative_experience'},$Meta->{'Group_favorite'},$Meta->{'Star_rating'},$Meta->{'Del'},$Meta->{'Groups'},$Meta->{'Number_comments'},$Meta->{'Ave_rating'});
		@brickid = (@brickid,[$Meta->{'Com_id'},$j]);
		$i=$i+1;
	}
	@brickid = sort{$a->[1] <=> $b->[1]}@brickid;
	for($j=$#brickid; $j>=0; $j--){
		if($brickid[$j][1] < 30){
			last;
		}
		print $brickid[$j][0],"\t",sprintf "%.2f\n",$brickid[$j][1];	
	}
	print ">\n";
}

# clean up
$dbh->disconnect();
    exit(0);

