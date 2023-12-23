use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);

my $input = read_file('input.txt');
my @map = map({ [split '', $_] } split('\n', $input));

sub areNeighbors($ai, $aj, $bi, $bj, $dirIdx) {
  # say "$ai $aj $bi $bj $dirIdx";
  return 1 if $dirIdx == 0 && ($map[$ai][$aj] ne '7' && $map[$ai][$aj] ne 'F' && $map[$ai][$aj] ne '-') && ($map[$bi][$bj] ne 'J' && $map[$bi][$bj] ne 'L' && $map[$bi][$bj] ne '-');
  return 1 if $dirIdx == 1 && ($map[$ai][$aj] ne 'J' && $map[$ai][$aj] ne 'L' && $map[$ai][$aj] ne '-') && ($map[$bi][$bj] ne '7' && $map[$bi][$bj] ne 'F' && $map[$bi][$bj] ne '-');
  return 1 if $dirIdx == 2 && ($map[$ai][$aj] ne 'L' && $map[$ai][$aj] ne 'F' && $map[$ai][$aj] ne '|') && ($map[$bi][$bj] ne 'J' && $map[$bi][$bj] ne '7' && $map[$bi][$bj] ne '|');
  return 1 if $dirIdx == 3 && ($map[$ai][$aj] ne 'J' && $map[$ai][$aj] ne '7' && $map[$ai][$aj] ne '|') && ($map[$bi][$bj] ne 'L' && $map[$bi][$bj] ne 'F' && $map[$bi][$bj] ne '|');
  if ($map[$ai][$aj] eq 'S') {
    return 1 if $dirIdx == 0 && ($map[$bi][$bj] ne 'J' && $map[$bi][$bj] ne 'L' && $map[$bi][$bj] ne '-');
    return 1 if $dirIdx == 1 && ($map[$bi][$bj] ne '7' && $map[$bi][$bj] ne 'F' && $map[$bi][$bj] ne '-');
    return 1 if $dirIdx == 2 && ($map[$bi][$bj] ne 'L' && $map[$bi][$bj] ne 'F' && $map[$bi][$bj] ne '|');
    return 1 if $dirIdx == 3 && ($map[$bi][$bj] ne 'J' && $map[$bi][$bj] ne '7' && $map[$bi][$bj] ne '|');
  }
  return 0;
}

my ($sline) = grep { grep { $_ eq 'S'} @{$map[$_]} } (0 .. $#map);
my ($scol) = grep { $map[$sline][$_] eq 'S' } (0 .. $#{$map[$sline]});
my ($n, $m) = (scalar @map, scalar @{$map[0]});

my @dist = map({ [map({ 1<<60 } @{$map[0]})] } @map);
$dist[$sline][$scol] = 0;

my @dirs = ([-1, 0], [1, 0], [0, -1], [0, 1]);
my @queue = ([$sline, $scol]);
my $maxDist = 0;
while (@queue) {
  my ($line, $col) = @{shift @queue};
  # say "$line $col " . $dist[$line][$col] . " $maxDist";
  for my $dirIdx (0 .. $#dirs) {
    my $dir = $dirs[$dirIdx];
    my ($nline, $ncol) = ($line + $dir->[0], $col + $dir->[1]);
    next if $nline < 0 || $nline >= $n || $ncol < 0 || $ncol >= $m;
    next if $map[$nline][$ncol] eq '.';
    next unless areNeighbors($line, $col, $nline, $ncol, $dirIdx);
    next if $dist[$nline][$ncol] <= $dist[$line][$col] + 1;
    $dist[$nline][$ncol] = $dist[$line][$col] + 1;
    $maxDist = $dist[$nline][$ncol] if $dist[$nline][$ncol] > $maxDist;
    push @queue, [$nline, $ncol];
  }
}
say $maxDist;

