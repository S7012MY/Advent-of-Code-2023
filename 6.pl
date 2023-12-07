use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);

chomp (my $input = read_file('input.txt'));
my ($distances) = ($input =~ /Distance:((?: +\d+)+)/g);
my ($times) = ($input =~ /Time:((?: +\d+)+)/g);
my @distances = split(' ', $distances);
my @times = split(' ', $times);

my $res = 1;
for my $i (0 .. $#times) {
  my $valid = 0;
  for my $time (0 .. $times[$i]) {
    ++$valid if ($time * ($times[$i] - $time) > $distances[$i])
  }
  $res *= $valid;
}

say $res;