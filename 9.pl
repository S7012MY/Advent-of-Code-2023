use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);
use List::Util qw(sum);

my $input = read_file('input.txt');
my @sequences = map { [split ' ', $_] } (split '\n', $input);

sub getNextElement(@sequence) {
  my $allZeroes = 1;
  for (my $i = 0; $i < @sequence; ++$i) {
    if ($sequence[$i] != 0) {
      $allZeroes = 0;
      last;
    }
  }
  if ($allZeroes) {
    return 0;
  }
  my $getNextElement = getNextElement(map { $sequence[$_] - $sequence[$_-1] } (1 .. $#sequence));
  return $getNextElement + $sequence[-1];
}

say sum(map {getNextElement(@$_) } @sequences);