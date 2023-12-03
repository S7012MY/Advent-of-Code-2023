use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);
use List::Util qw(sum);

chomp (my $input = read_file('input.txt'));
my $sum = 0;

my %wordToNumber = (
  one => 1,
  two => 2,
  three => 3,
  four => 4,
  five => 5,
  six => 6,
  seven => 7,
  eight => 8,
  nine => 9,
  1 => 1,
  2 => 2,
  3 => 3,
  4 => 4,
  5 => 5,
  6 => 6,
  7 => 7,
  8 => 8,
  9 => 9
);

say sum(map {
  my @matches = ($_ =~ /(?=(\d|one|two|three|four|five|six|seven|eight|nine))/g);
  my ($a, $b) = ($wordToNumber{$matches[0]}, $wordToNumber{$matches[-1]});
  if (!defined $a || !defined $b) {
    die "a: $a, b: $b, matches: @matches";
  }
  # say "$a $b";
  ($a * 10 + $b);
} split /\n/, $input);
