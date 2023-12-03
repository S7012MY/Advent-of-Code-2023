use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);
use List::Util qw(sum);

chomp (my $input = read_file('input.txt'));
my $sum = 0;

say sum(map {
  my @matches = ($_ =~ /(\d)/g);
  $matches[0] * 10 + $matches[-1];
} split /\n/, $input);
