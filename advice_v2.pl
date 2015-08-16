#!/usr/bin/perl

use DBI;

# parameters
my $host = "localhost";
my $dbname = "base";
my $username = "root";
my $password = "huangwenze";

my $object = $ARGV[0];
my $type = $ARGV[1];
my $func = $ARGV[2];
my @brickid = ();
@brickid = split(/\*/,$object);
@cand = ();
@return = ();
my $score = 0;
my $cscore = 0;
my $rscore = 0;
my $i = 0;
my $j = 0; 
my $r = 0;      
my $dbh = DBI->connect("DBI:mysql:database=$dbname;host=$host", "$username", "$password") || die "connection failed: ". DBI->errstr;

@devic = split(/\*/,$object);


# execute INSERT query using do()
# my $rows = $dbh->do("INSERT INTO user (Host, User) VALUES ('localhost', 'xiongyitest1215')");

# execute SELECT query
my $sth1 = $dbh->prepare("SELECT Bri_id,Score FROM brick where (Btype like '%".$type."%') and (Des like '%".$func."%')");
$sth1->execute();
while(my $Can = $sth1->fetchrow_hashref()) {
	if($Can->{'Score'} >= 0.0){
		@cand = (@cand,[$Can->{'Bri_id'},$Can->{'Score'}]);
	}
}
for($i=0;$i<=$#cand;$i++){
	print $cand[$i][0],"\t",$cand[$i][1],"\n";
}

for($i=0;$i<=$#cand;$i++){
	$cscore = 0;
	for($j=0;$j<=$#brickid;$j++){
		$score = 0;
		$r = 0;
		my $sth1 = $dbh->prepare("SELECT S.Com_id,S.Bri_id,T.Bri_id,R.Score FROM (contain as S join contain as T on S.Com_id = T.Com_id) join combine as R on S.Com_id = R.Com_id where (S.Bri_id = '".$cand[$i][0]."') and (T.Bri_id = '".$brickid[$j]."')");
		$sth1->execute();
		while(my $Meta = $sth1->fetchrow_hashref()) {
			$score = $score + $Meta->{'R.Score'};
			$r = $r + 1;
		}
		if($r == 0){
		$cscore = $cscore + $score;
		}else{
			$score = $score/$r;
			$cscore = $cscore + $score;
		}
	}
	$rscore = 0.65 * $cand[$i][1] + 0.35 * $cscore;
	@return = (@return,[$cand[$i][0],$rscore]);
}
@return = sort{$a->[1] <=> $b->[1]}@return;
for($j=$#return; $j>=0; $j--){
	if($return[$j][1] < 10){
		last;
	}
	print $return[$j][0],"|",sprintf "%.2f\n",$return[$j][1];	
}

print ">>\n";

# clean up
$dbh->disconnect();
    exit(0);