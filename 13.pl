use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);

my $input = read_file('input.txt');

sub printMatrix(@matrix) {
  say join "\n", map { join "", @$_ } @matrix;
  say "\n";
}

sub findReflexion(@matrix) {
  my $num = 0;
  for my $lineIdx (1 .. @matrix - 1) {
    my $match = 1;
    for my $dif (0 .. @matrix) {
      last if $lineIdx - $dif - 1 < 0 || $lineIdx + $dif >= @matrix;
        # compare lines $lineIdx - 1 - $dif and $lineIdx + $dif
      $match &&= join("", @{$matrix[$lineIdx - 1 - $dif]}) eq join("", @{$matrix[$lineIdx + $dif]});
    }
    $num += $lineIdx if $match;
    say $lineIdx if $match;
  }
  return $num;
}

sub rotateMatrixClockwise(@matrix) {
  my @res;
  for my $colIdx (0 .. @{$matrix[0]} - 1) {
    push @res, [ map { $matrix[$_->[0]][$_->[1]] } (map { [$_, $colIdx] } 0 .. @matrix - 1) ];
  }
  return @res;
}

my $res = 0;
for my $matrix (split /\n\n/, $input) {
  my @matrix = map { [ split //, $_] } split /\n/, $matrix;
  my $reflexion = findReflexion(@matrix);
  if ($reflexion) {
    $res += 100 * $reflexion;
    next;
  }
  $res += findReflexion(rotateMatrixClockwise(@matrix));
  say "\n";
}
say $res;