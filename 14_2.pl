use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);

my $input = read_file('input.txt');
my @map = map { [ split //, $_] } split /\n/, $input;

my @di = (-1, 0, 1, 0);
my @dj = (0, -1, 0, 1);

sub matrixToString(@matrix) {
  my $str = join "\n", map { join '', @$_ } @matrix;
  return $str;
}

sub moveStones($d, @map) {
  my ($startI, $endI, $stepI) = $di[$d] < 0 ? (0, scalar @map, 1) : (@map - 1, -1, -1);
  my ($startJ, $endJ, $stepJ) = $dj[$d] < 0 ? (0, scalar @{$map[0]}, 1) : (@{$map[0]} - 1, -1, -1);

  for (my $i = $startI; $i != $endI; $i += $stepI) {
    for (my $j = $startJ; $j != $endJ; $j += $stepJ) {
      next if $map[$i][$j] ne 'O';
      my ($ci, $cj) = ($i, $j);
      while (1) {
        my ($ni, $nj) = ($ci + $di[$d], $cj + $dj[$d]);
        last if $ni < 0 || $ni >= @map || $nj < 0 || $nj >= @{$map[0]};
        last if $map[$ni][$nj] eq '#' || $map[$ni][$nj] eq 'O';
        ($ci, $cj) = ($ni, $nj);
      }
      next if $ci == $i && $cj == $j;
      $map[$ci][$cj] = 'O';
      $map[$i][$j] = '.';
    }
  }
}

sub totalLoad($d, @map) {
  my $total = 0;
  for my $i (0 .. @map - 1) {
    for my $j (0 .. @{$map[0]} - 1) {
      next if $map[$i][$j] ne 'O';
      $total += (@map - $i);
    }
  }
  return $total;
}

my %seen;
my $cycles = 0;
my $totalCycles = 1000000000;
my $remainingCyclesInCycle;
while (1) {
  for my $d (0 .. 3) {
    moveStones($d, @map);
  }
  # say matrixToString(@map) . "\n";
  ++$cycles;
  if ($seen{matrixToString(@map)}) {
    my $cycleLength = $cycles - $seen{matrixToString(@map)};
    say "Cycle length: $cycleLength total cycles: $cycles lastSeen: $seen{matrixToString(@map)}";
    my $remainingCycles = $totalCycles - $cycles;
    $remainingCyclesInCycle = $remainingCycles % $cycleLength;
    last;
  }
  $seen{matrixToString(@map)} = $cycles;
}

for (1 .. $remainingCyclesInCycle) {
  for my $d (0 .. 3) {
    moveStones($d, @map);
  }
}
say totalLoad(2, @map);