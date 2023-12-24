use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);

my @map = map { [split //] } split /\n/, read_file('input.txt');

my @di = (0, 1, 0, -1);
my @dj = (1, 0, -1, 0);
my %nextD;
$nextD{0}{'/'} = 3;
$nextD{1}{'/'} = 2;
$nextD{2}{'/'} = 1;
$nextD{3}{'/'} = 0;
$nextD{0}{'\\'} = 1;
$nextD{1}{'\\'} = 0;
$nextD{2}{'\\'} = 3;
$nextD{3}{'\\'} = 2;

sub energy($si, $sj, $d) {
  my @beams;
  my @q = ([$si, $sj, $d]);
  while (@q) {
    my ($i, $j, $d) = @{shift @q};
    next if 0 > $i || $i >= @map || 0 > $j || $j >= @{$map[$i]} || grep { $_ == $d } @{$beams[$i][$j]};
    push @{$beams[$i][$j]}, $d;
    if ($map[$i][$j] eq '.' || ($map[$i][$j] eq '|' && $d % 2) || ($map[$i][$j] eq '-' && !($d % 2))) {
      push @q, [$i + $di[$d], $j + $dj[$d], $d];
    } elsif ($map[$i][$j] =~ /[\/\\]/) {
      my $newD = $nextD{$d}{$map[$i][$j]};
      push @q, [$i + $di[$newD], $j + $dj[$newD], $newD];
    } elsif ($map[$i][$j] eq '|') {
      push @q, [$i + $di[1], $j + $dj[1], 1];
      push @q, [$i + $di[3], $j + $dj[3], 3];
    } elsif ($map[$i][$j] eq '-') {
      push @q, [$i + $di[0], $j + $dj[0], 0];
      push @q, [$i + $di[2], $j + $dj[2], 2];
    }
  }

  my $res = grep { defined $_ } map { $_ ? @$_ : [] } @beams;
  return $res;
}

my $maxEnergy = 0;
for my $i (0 .. @map - 1) {
  my $currentEnergy = energy($i, 0, 0);
  $maxEnergy = $currentEnergy if $currentEnergy > $maxEnergy;
  $currentEnergy = energy($i, @{$map[$i]} - 1, 2);
  $maxEnergy = $currentEnergy if $currentEnergy > $maxEnergy;
}
for my $j (0 .. @{$map[0]} - 1) {
  my $currentEnergy = energy(0, $j, 1);
  $maxEnergy = $currentEnergy if $currentEnergy > $maxEnergy;
  $currentEnergy = energy(@map - 1, $j, 3);
  $maxEnergy = $currentEnergy if $currentEnergy > $maxEnergy;
}
say $maxEnergy;