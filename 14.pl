use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);

my $input = read_file('input.txt');
my @map = map { [ split //, $_] } split /\n/, $input;

my @di = (-1, 0, 1, 0);
my @dj = (0, -1, 0, 1);

sub printMatrix(@matrix) {
  say join "\n", map { join '', @$_ } @matrix;
  say '';
}

sub moveStones($d, @map) {
  for my $i (0 .. @map - 1) {
    for my $j (0 .. @{$map[0]} - 1) {
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

moveStones(0, @map);
printMatrix(@map);
say totalLoad(2, @map);