use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);

chomp (my $input = read_file('input.txt'));
my @board = map { [split //, $_] } split /\n/, $input;
my @dirs = ([-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [-1, 1], [1, -1], [1, 1]);
my %finalNumber;
my %numberIds;

sub isInside($row, $col) {
  return $row >= 0 && $row <= $#board && $col >= 0 && $col <= $#{$board[$row]};
}

my $sum = 0;
my $id = 0;
for my $row (0..$#board) {
  my $num = 0;
  my @currentPositions;
  for my $col (0..$#{$board[$row]}) {
    if ($board[$row][$col] =~ /\d/) {
      $num = $num * 10 + $board[$row][$col];
      push @currentPositions, $col;
    }
    next unless $num;
    if ($board[$row][$col] !~ /\d/ || $col == $#{$board[$row]}) {
      for my $pos (@currentPositions) {
        $finalNumber{"$row|$pos"} = $num;
        $numberIds{"$row|$pos"} = $id;
      }
      $num = 0;
      ++$id;
      @currentPositions = ();
    }
  }
}

for my $row (0..$#board) {
  for my $col (0..$#{$board[$row]}) {
    if ($board[$row][$col] eq '*') {
      my $product = 1;
      my %usedIds;
      my $found = 0;
      for my $dir (@dirs) {
        my ($newRow, $newCol) = ($row + $dir->[0], $col + $dir->[1]);
        if (isInside($newRow, $newCol) && $finalNumber{"$newRow|$newCol"} && !$usedIds{$numberIds{"$newRow|$newCol"}}) {
          # say "$row $col $newRow $newCol " . $finalNumber{"$newRow|$newCol"};
          $product *= $finalNumber{"$newRow|$newCol"};
          $usedIds{$numberIds{"$newRow|$newCol"}} = 1;
          ++$found;
        }
      }
      $sum += $product if $found > 1;
    }
  }
}

say $sum;