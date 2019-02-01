#!/import/bc2/soft/bin/perl5/perl -w
# /usr/bin/perl -w
use strict;
my $MAX_PROCESSES = shift || 10;
use Parallel::ForkManager;
my $pm = new Parallel::ForkManager($MAX_PROCESSES);
while(<>){
  my $pid = $pm->start and next; 
  system($_);
  $pm->finish; # Terminates the child process
}

