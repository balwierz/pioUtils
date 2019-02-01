#!/import/bc2/soft/app/perl/5.10.1/Linux/bin/perl -w
use strict;

my $lastBarcode = "";
my $lastSeq = "";
my $i=0;
my %dict;
my %allBarcodes=  ();
while(<>)
{
	chomp;
	if(/^>([ACGT]+)\s/)
	{
		if($lastSeq)
		{
			if(not defined $dict{$lastSeq}{$lastBarcode})
			{
				$dict{$lastSeq}{$lastBarcode} = 0;
			}
			$dict{$lastSeq}{$lastBarcode} += 1;
		}
		$allBarcodes{$1} = 1;
		$lastBarcode = $1;
		$lastSeq = "";
		$i++;
		if(! ($i % 100000))
		{
			print STDERR "At line $i\n";
		}
	}
	else
	{
		$lastSeq .= $_;
	}
}
# last line.
if(not defined $dict{$lastSeq}{$lastBarcode})
{
	$dict{$lastSeq}{$lastBarcode} = 0;
}
$dict{$lastSeq}{$lastBarcode} += 1;
# AATGCGA TTCGTCA AGATACA CGTATTA GAAGCCA TCTATAA AGCATAA ATACGCA CCATGAA TATCGTA CGCTCGA TTCCGAA GCGCTGA CCGAATA GCTGAAA GTCGCGA
print "#\t". join("\t", sort keys %allBarcodes), "\t", "seq\n";
foreach my $seq (keys %dict)
{
	print ">";
	foreach my $barcode (sort keys %allBarcodes)
	{
		my $num = exists $dict{$seq}{$barcode} ? $dict{$seq}{$barcode} : 0;
		print "\t", $num;
	}
	print "\t", $seq, "\n";
}
