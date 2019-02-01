#!/mnt/biggles/opt/perl/bin/perl -w
use strict;

my $f = shift @ARGV or die "usage: command file stub 40,130 180,220\n";
my $stub = shift @ARGV;
my $fH;
if($f =~ /\.bam$/)
{
	open($fH, '-|', 'samtools', 'view', '-h', $f) or die;
}
elsif($f =~ /\.sam$/)
{
	open($fH, $f) or die;
}
my %len2fh;
my @allFh = ();
while(my $pair = shift @ARGV)
{
	die $pair." is bad\n" unless $pair =~ /^\d+\,\d+$/;
	my($a, $b) = split(/,/, $pair);
	open(my $fh, '>', "$stub.$a,$b") or die;

	# print the header:
	#~ open(my $f2H, '-|', 'samtools', 'view', '-H', $f) or die;
	#~ while(<$f2H>) 
	#~ {
		#~ print $fh $_
	#~ }
	#~ close $f2H;
	
	push @allFh, $fh;
	for(my $i=$a; $i<$b; $i++)
	{
		$len2fh{$i} = $fh;
	}
}
while(<$fH>)
{
	# header goes to all the files:
	if($_ =~ /^@/)
	{
		foreach my $fh (@allFh)
		{
			print $fh $_;
		}
	}
	else
	{
		my @v = split(/\t/);
		my $frgmLen = abs($v[8]);
		my $fh = exists $len2fh{$frgmLen} ? $len2fh{$frgmLen} : 0;
		if($fh)
		{
			print $fh $_;
		}
	}
}
close $fH;

# close all the file handles:
