#!/mnt/biggles/opt/perl/bin/perl -w
use strict;

my $pattern = '^chr\d'; #watch out, no chrM!!

open(my $fH, shift @ARGV) or die;
while(<$fH>)
{
	if(/^\@/)
	{
		if(/^\@SQ/)
		{
			my($h, $field, $len) = split(/\t/);
			my($foo, $chr) = split(/:/, $field);
			print if $chr =~ $pattern;
		}
		else
		{
			print
		}
	}
	else
	{
		my($id, $field2, $chr) = split(/\t/);
		print if $chr =~ $pattern;
	}
}
close $fH;
