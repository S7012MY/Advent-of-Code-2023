use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);

my @map = map { [split //] } split /\n/, read_file('input.txt');

sub isInside($i, $j) {
  return 0 <= $i && $i < @map && 0 <= $j && $j < @{$map[$i]};
}

my @di = (0, 1, 0, -1);
my @dj = (1, 0, -1, 0);
my @minHeat;

my @q = ([0, 0, 0, 0], [0, 0, 1, 0]);
$minHeat[0][0][0][0] = 0;
$minHeat[0][0][1][0] = 0;
my $bestHeat = 1000000000;

while (@q) {
  my ($i, $j, $d, $consec) = @{shift @q};
  # say "$i $j $d $consec $minHeat[$i][$j][$d][$consec]";
  if ($i == @map - 1 && $j == @{$map[@map - 1]} - 1) {
    $bestHeat = $minHeat[$i][$j][$d][$consec] if $minHeat[$i][$j][$d][$consec] < $bestHeat;
  }
  
  my $newD;
  my ($ii, $jj) = ($i + $di[$d], $j + $dj[$d]);
  if (isInside($ii, $jj) && $consec < 2 && (!$minHeat[$ii][$jj][$d][$consec + 1] || $minHeat[$ii][$jj][$d][$consec + 1] > $minHeat[$i][$j][$d][$consec] + $map[$ii][$jj])) {
    $minHeat[$ii][$jj][$d][$consec + 1] = $minHeat[$i][$j][$d][$consec] + $map[$ii][$jj];
    push @q, [$ii, $jj, $d, $consec + 1];
  }
  $newD = ($d + 1) % 4;
  ($ii, $jj) = ($i + $di[$newD], $j + $dj[$newD]);
  if (isInside($ii, $jj) && (!$minHeat[$ii][$jj][$newD][0] || $minHeat[$ii][$jj][$newD][0] > $minHeat[$i][$j][$d][$consec] + $map[$ii][$jj])) {
    $minHeat[$ii][$jj][$newD][0] = $minHeat[$i][$j][$d][$consec] + $map[$ii][$jj];
    push @q, [$ii, $jj, $newD, 0];
  }
  $newD = ($d + 3) % 4;
  ($ii, $jj) = ($i + $di[$newD], $j + $dj[$newD]);
  if (isInside($ii, $jj) && (!$minHeat[$ii][$jj][$newD][0] || $minHeat[$ii][$jj][$newD][0] > $minHeat[$i][$j][$d][$consec] + $map[$ii][$jj])) {
    $minHeat[$ii][$jj][$newD][0] = $minHeat[$i][$j][$d][$consec] + $map[$ii][$jj];
    push @q, [$ii, $jj, $newD, 0];
  }
}

say $bestHeat;