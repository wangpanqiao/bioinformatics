#!/usr/bin/perl -w
use strict;
use warnings;
my $BEGIN_TIME=time();
use Getopt::Long;
my ($fIn,$dOut,$only,$dsh);
use Data::Dumper;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
my $version="1.0.0";
GetOptions(
	"help|?" =>\&USAGE,
	"input:s"=>\$fIn,
	"out:s"=>\$dOut,
	"split:s"=>\$only,
			) or &USAGE;
&USAGE unless ($fIn and $dOut and $dsh);
open In,$fIn;
mkdir $dOut if (!-d $dOut);
$dOut=ABSOLUTE_DIR($dOut);
my $head;
$only||=200;
my @Marker;
while (<In>) {
	chomp;
	next if ($_ eq "" ||/^$/);
	if (/^#/) {
		$head =$_;
		next;
	}else{
		push @Marker,$_;
	}
}
close In;
my $split= int(scalar @Marker / $only);
open List,">dOut/sub.marker.list";
for (my $i=0;$i<$split;$i++) {
	open Out,">$dOut/sub.$i.genotype";
	print Out $head,"\n";
	for (my $j= $only*$i;$j<@Marker;$j++) {
		print Out $Marker[$j],"\n";
	}
	close Out;
	print List "$i\t$dOut/sub.$i.genotype\n";
}
close SH;
close List;

#######################################################################################
print STDOUT "\nDone. Total elapsed time : ",time()-$BEGIN_TIME,"s\n";
#######################################################################################
sub ABSOLUTE_DIR #$pavfile=&ABSOLUTE_DIR($pavfile);
{
	my $cur_dir=`pwd`;chomp($cur_dir);
	my ($in)=@_;
	my $return="";
	if(-f $in){
		my $dir=dirname($in);
		my $file=basename($in);
		chdir $dir;$dir=`pwd`;chomp $dir;
		$return="$dir/$file";
	}elsif(-d $in){
		chdir $in;$return=`pwd`;chomp $return;
	}else{
		warn "Warning just for file and dir \n$in";
		exit;
	}
	chdir $cur_dir;
	return $return;
}

sub USAGE {#
        my $usage=<<"USAGE";
Contact:        long.huang\@majorbio.com;
Script:			$Script
Description:
	fq thanslate to fa format
	eg:
	perl $Script -i -o -k -c

Usage:
  Options:
  -input	<file>	input file name
  -out	<dir>	output file dir
  -dsh	<dir>	output worksh dir
  -split	<num>	split number 
  -h         Help

USAGE
        print $usage;
        exit;
}
