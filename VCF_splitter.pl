#!/usr/bin/perl

#############################################################
###	given a large vcf, extract the individuals wanted	    ###
###	using their IDs										                    ###
### INPUT: list of IDs									                  ###
### STDIN: VCF file										                    ###
###	chris clarkson csc@liv.ac.uk						              ###
#############################################################

use strict; 
use warnings;
use List::MoreUtils qw(first_index);

my $indvs = $ARGV[0];
open (INDVS, $indvs) || die "shit the bed";

my @allindv;

while (my $line = <INDVS>){
	chomp($line);
	push(@allindv, $line);
}

my @indexes;

while (my $line = <STDIN>){
	if ($line =~ m/^\#\#/ ) {
		print "$line";
	}
	if ($line =~ m/^\#CHROM/ ){
	my @temp = split(/\t/ , $line);
		foreach my $place (@allindv) {
		push @indexes, first_index { $_ eq $place } @temp;
		}		
	my @header = @temp[0..8];
	print join("\t", @header);
	print "\t";
	print join("\t", @allindv);
	print "\n";
	}
	if ($line =~ m/^2L|^2R|^3L|^3R|^X/) {
	my @tempoo = split(/\t/ , $line);
	my @columns = @tempoo[0..8];
	my @chosen = @tempoo[@indexes[0..11]];
	print join ("\t", @columns);
	print "\t";
	print join ("\t", @chosen);
	print "\n";
	}
	
}

close INDVS;


