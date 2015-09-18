#!/usr/bin/perl

use DBI;

# parameters
my $host = "localhost";
my $dbname = "base";
my $username = "root";
my $password = "";

my $object = $ARGV[0];
my $type = $ARGV[1];
my $i=0;
my @brickid=();
my @score=();
my @unis=();
my $j=0.0;       
my $dbh = DBI->connect("DBI:mysql:database=$dbname;host=$host", "$username", "$password") || die "connection failed: ". DBI->errstr;

@uni=split(/\*/,$object);


if($type eq "brick"){
	my $sth1 = $dbh->prepare("insert into brick values('".$uni[0]."','".$uni[1]."','".$uni[2]."','".$uni[3]."','".$uni[4]."','".$uni[5]."','".$uni[6]."',0,0,'".$uni[7]."','".$uni[8]."','".$uni[9]."','".$uni[10]."','".$uni[11]."',0,0,-1,'".$uni[12]."',0)");
    $sth1->execute();
}elsif($type eq "devic"){
	my $sth1 = $dbh->prepare("insert into combine values('".$uni[0]."','".$uni[1]."','".$uni[2]."','".$uni[3]."','".$uni[4]."','".$uni[5]."','".$uni[6]."',0,0,'".$uni[7]."','".$uni[8]."','".$uni[9]."','".$uni[10]."','".$uni[11]."',0,0,-1,'".$uni[12]."',0)");
    $sth1->execute();
}

# clean up
$dbh->disconnect();
    exit(0);