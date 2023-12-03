use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);

chomp (my $input = read_file('input.txt'));
my @board = map { [split //, $_] } split /\n/, $input;
my @dirs = ([-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [-1, 1], [1, -1], [1, 1]);

sub isInside($row, $col) {
  return $row >= 0 && $row <= $#board && $col >= 0 && $col <= $#{$board[$row]};
}

my $sum = 0;
for my $row (0..$#board) {
  my $num = 0;
  my $isAdjacent = 0;
  for my $col (0..$#{$board[$row]}) {
    if ($board[$row][$col] =~ /\d/) {
      $num = $num * 10 + $board[$row][$col];
      for my $dir (@dirs) {
        my ($newRow, $newCol) = ($row + $dir->[0], $col + $dir->[1]);
        if (isInside($newRow, $newCol) && $board[$newRow][$newCol] ne '.' && $board[$newRow][$newCol] !~ /\d/) {
          $isAdjacent = 1;
        }
      }
    }
    if ($board[$row][$col] !~ /\d/ || $col == $#{$board[$row]}) {
      # say "$row $col $num $isAdjacent";
      if ($isAdjacent) {
        $sum += $num;
      }
      $num = 0;
      $isAdjacent = 0;
    }
  }
}

say $sum;