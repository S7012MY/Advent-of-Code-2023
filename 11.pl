use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);

my $input = read_file('input.txt');
my @map = map({ [split '', $_] } split('\n', $input));
say join "\n", map { join '', @{$_} } @map;

my @allIndexes = map { my $i = $_; map { [$i, $_] } (0 .. $#{$map[$i]}) } (0 .. $#map);
my @allPoints = grep { $map[$_->[0]][$_->[1]] eq '#' } @allIndexes;
my @freeLines = grep { my $i = $_; !grep { $map[$i][$_] eq '#'} (0 .. $#{$map[$i]}) } (0 .. $#map);
my @freeColumns = grep { my $j = $_; !grep { $map[$_][$j] eq '#'} (0 .. $#{$map[$j]}) } (0 .. $#{$map[0]});

sub mhtDist($ai, $aj, $bi, $bj) {
  # say "$ai $aj $bi $bj";
  my ($minI, $maxI) = ($ai < $bi ? ($ai, $bi) : ($bi, $ai));
  my ($minJ, $maxJ) = ($aj < $bj ? ($aj, $bj) : ($bj, $aj));
  my $betweenI = grep { $minI < $_ && $_ < $maxI } @freeLines;
  my $betweenJ = grep { $minJ < $_ && $_ < $maxJ } @freeColumns;

  # say "$minI $maxI $minJ $maxJ $betweenI $betweenJ";
  return ($maxI - $minI) + ($maxJ - $minJ) + $betweenI + $betweenJ;
}

my $sumDist = 0;
for my $i (0 .. $#allPoints) {
  for my $j ($i + 1 .. $#allPoints) {
    my ($ai, $aj) = @{$allPoints[$i]};
    my ($bi, $bj) = @{$allPoints[$j]};
    if ($i == 2 && $j == 5) {
      # say mhtDist($ai, $aj, $bi, $bj);
    }
    $sumDist += mhtDist($ai, $aj, $bi, $bj);
  }
}

say $sumDist;