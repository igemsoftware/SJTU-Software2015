#!/usr/bin/perl

# parameters
my $host = "localhost";
my $dbname = "base";
my $username = "root";
my $password = "";

my $object = $ARGV[0];
my $type = $ARGV[1];


sub judge{
	my ($object,$type,$host,$dbname,$username,$password) = @_;
	use DBI;	
	my $dbh = DBI->connect("DBI:mysql:database=$dbname;host=$host", "$username", "$password") || die "connection failed: ". DBI->errstr;
	my @id = ();
	# execute INSERT query using do()
	# my $rows = $dbh->do("INSERT INTO user (Host, User) VALUES ('localhost', 'xiongyitest1215')");
	
	# execute SELECT query
	my $sth1 = $dbh->prepare("SELECT Bri_id,Score FROM brick where (Btype like '%".$type."%') and (Bri_id = '".$object."')");
	$sth1->execute();
	
	while(my @Meta = $sth1->fetchrow_array()){
		@id=(@id,$Meta[0]);
	}
	if(@id){
		print "Yes\n";
	}else{
		print "No\n";
	}
	
	# clean up
	$dbh->disconnect();
}

judge($object,$type,$host,$dbname,$username,$password);



exit(0);
