#!/usr/bin/perl

####################################################################
####	creates non-overlapping windowed mean/geomean/median    	####
####	INPUT = vcftools FST output							                	####
####															                              ####
####	Chris Clarkson csc@liv.ac.uk							                ####
####################################################################

use strict; 
use warnings;
use Statistics::Descriptive;

print "\n\nhereth enter thee name ov output\n\n";

chomp(my $title = <STDIN>);

print "\n\nto proceed thou must now define window size\n\n";

chomp(my $winsize = <STDIN>);


my $input = $ARGV[0];

open (INPUT, $input) || die "cor, me input has gone all wonkz";
open (OUTPUT, ">$title".".txt") || die "halp! output down! medic!";

my $counter = 0;
my $start;
my $end;
my $contig;
my @winAA;

print OUTPUT "contig\tstart\tend\tmid\tAAmean\tAAvar\tAAmin\tAAmed\tAAgeo\n";


while(my $line = <INPUT>){
	if ($line !~ /^C/){
		$counter ++;
		if ($counter < $winsize ) {
			my @split = split(/\t/ ,$line);
			if ($counter == 1) {
				$start = $split[1];
			}
			chomp($split[2]);
			push (@winAA, $split[2]);		 
			
		}
		if ($counter == $winsize ) {
			my @split = split(/\t/ , $line);
			$contig = $split[0];
			$end = $split[1];
			chomp($split[2]);
			push (@winAA, $split[2]);

			(my $AAmean, my $AAvar, my $AAmin, my $AAmed, my $AAgeo) = &mean(@winAA);
			my $mid = ($end + $start)/2;
			print OUTPUT "$contig\t$start\t$end\t$mid\t$AAmean\t$AAvar\t$AAmin\t$AAmed\t$AAgeo\n";
			undef @winAA;
			$counter = 0;
		}
	}
}


sub mean
{
my $stat = Statistics::Descriptive::Sparse->new();
$stat ->add_data(@_);
my $submean = $stat->mean();
my $subvar = $stat->variance();
my $submin = $stat->min();
my $fullstat = Statistics::Descriptive::Full->new();
$fullstat ->add_data(@_);
my $submedian = $fullstat->median();
my $subgeo = $fullstat->geometric_mean();
return ($submean, $subvar, $submin, $submedian, $subgeo);
} 



close OUTPUT;
close INPUT;


