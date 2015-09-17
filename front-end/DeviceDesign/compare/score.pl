#!/usr/bin/perl -w
use strict;

#input,split by ,
my ($device) = $ARGV[0]; #input the biobrick ID
my ($description) = $ARGV[1];#input the key word
my ($cutoff) = $ARGV[2];#input the precision

use basefunc;
evaluate($device,$description,$cutoff);

no basefunc;

exit(0);


	

