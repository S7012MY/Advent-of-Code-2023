use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);

my $input = read_file('input.txt');

sub printMatrix(@matrix) {
  say join "\n", map { join "", @$_ } @matrix;
  say "\n";
}

sub findReflexion(@matrix) {
  # printMatrix(@matrix);
  for my $lineIdx (1 .. @matrix - 1) {
    my $match = 1;
    for my $dif (0 .. @matrix) {
      last if $lineIdx - $dif - 1 < 0 || $lineIdx + $dif >= @matrix;
      # compare lines $lineIdx - 1 - $dif and $lineIdx + $dif
      $match &&= join("", @{$matrix[$lineIdx - 1 - $dif]}) eq join("", @{$matrix[$lineIdx + $dif]});
    }
    return $lineIdx if $match;
  }
  return -1;
}

sub rotateMatrixClockwise(@matrix) {
  my @res;
  for my $colIdx (0 .. @{$matrix[0]} - 1) {
    push @res, [ map { $matrix[$_->[0]][$_->[1]] } (map { [$_, $colIdx] } 0 .. @matrix - 1) ];
  }
  return @res;
}

sub getReflexionNumber(@matrix) {
  my $reflexion = findReflexion(@matrix);
  return 100 * $reflexion if $reflexion > 0;
  my @clockwiseRotated = rotateMatrixClockwise(@matrix);
  $reflexion = findReflexion(@clockwiseRotated);
  return $reflexion if $reflexion > 0;
  return -1;
}

sub getOppositeCharacter($char) {
  return '#' if $char eq '.';
  return '.' if $char eq '#';
  return $char
}

my $res = 0;
for my $matrix (split /\n\n/, $input) {
  my @matrix = map { [ split //, $_] } split /\n/, $matrix;
  my $reflexionNumber = getReflexionNumber(@matrix);
  my $found = 0;
  for my $i (0 .. @matrix - 1) {
    for my $j (0 .. @{$matrix[0]} - 1) {
      my $initialChar = $matrix[$i][$j];
      $matrix[$i][$j] = getOppositeCharacter($matrix[$i][$j]);
      my $newReflexionNumber = getReflexionNumber(@matrix);
      if ($newReflexionNumber != -1 && $newReflexionNumber != $reflexionNumber) {
        $found = $newReflexionNumber;
        say "$i $j $found $reflexionNumber";
        last;
      }
      $matrix[$i][$j] = $initialChar;
    }
    last if $found;
  }
  $res += $found;
}
say $res;