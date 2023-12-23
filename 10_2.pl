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

$map[$sline][$scol] = '|' if $sline > 0 && $dist[$sline - 1][$scol] != 1<<60 && $sline < $n - 1 && $dist[$sline + 1][$scol] != 1<<60;
$map[$sline][$scol] = '-' if $scol > 0 && $dist[$sline][$scol - 1] != 1<<60 && $scol < $m - 1 && $dist[$sline][$scol + 1] != 1<<60;

$map[$sline][$scol] = 'L' if $sline > 0 && $dist[$sline - 1][$scol] != 1<<60 && $scol < $m - 1 && $dist[$sline][$scol + 1] != 1<<60;
$map[$sline][$scol] = 'J' if $sline > 0 && $dist[$sline - 1][$scol] != 1<<60 && $scol > 0 && $dist[$sline][$scol - 1] != 1<<60;
$map[$sline][$scol] = 'F' if $sline < $n - 1 && $dist[$sline + 1][$scol] != 1<<60 && $scol < $m - 1 && $dist[$sline][$scol + 1] != 1<<60;
$map[$sline][$scol] = '7' if $sline < $n - 1 && $dist[$sline + 1][$scol] != 1<<60 && $scol > 0 && $dist[$sline][$scol - 1] != 1<<60;
say "PROBLEM" if $map[$sline][$scol] eq 'S';

my (@map2, @dist2);
for my $line (0 .. $#map) {
  for my $col (0 .. $#{$map[$line]}) {
    $map2[2 * $line][2 * $col] = $map[$line][$col];
    $dist2[2 * $line][2 * $col] = $dist[$line][$col];
    $map2[2 * $line][2 * $col + 1] = '#';
    $dist2[2 * $line][2 * $col + 1] = 1<<60;
    $map2[2 * $line + 1][2 * $col] = '#';
    $dist2[2 * $line + 1][2 * $col] = 1<<60;
    $map2[2 * $line + 1][2 * $col + 1] = '#';
    $dist2[2 * $line + 1][2 * $col + 1] = 1<<60;
    if ($dist[$line][$col] != 1<<60) {
      if ($map[$line][$col] eq 'L' || $map[$line][$col] eq 'F' || $map[$line][$col] eq '-') {
        $map2[2 * $line][2 * $col + 1] = '-';
        $dist2[2 * $line][2 * $col + 1] = $dist[$line][$col];
      }
      if ($map[$line][$col] eq 'F' || $map[$line][$col] eq '7' || $map[$line][$col] eq '|') {
        $map2[2 * $line + 1][2 * $col] = '|';
        $dist2[2 * $line + 1][2 * $col] = $dist[$line][$col];
      }
    }
  }
}
@map = @map2;
@dist = @dist2;
($n, $m) = (scalar @map, scalar @{$map[0]});
say join "\n", map { join '', @{$_} } @map;

my $seenExterior = 0;
my $size = 0;
my %seen;
my $res = 0;

sub dfs($line, $col) {
  return if $seen{$line}{$col};
  $seen{$line}{$col} = 1;
  ++$size if $line % 2 == 0 && $col % 2 == 0;
  for my $dirIdx (0 .. $#dirs) {
    my $dir = $dirs[$dirIdx];
    my ($nline, $ncol) = ($line + $dir->[0], $col + $dir->[1]);
    if ($nline < 0 || $nline >= $n || $ncol < 0 || $ncol >= $m) {
      $seenExterior = 1;
      next;
    }
    next if $dist[$nline][$ncol] != 1<<60;
    dfs($nline, $ncol);
  }
}

for my $line (0 .. $#map) {
  for my $col (0 .. $#{$map[$line]}) {
    next if $dist[$line][$col] != 1<<60;
    next if $seen{$line}{$col};
    $size = 0;
    $seenExterior = 0;
    
    dfs($line, $col);
    $res += $size unless $seenExterior;
    # say "$line $col $size $seenExterior";
  }
}
say $res;
say "$n $m";

