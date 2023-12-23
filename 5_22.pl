use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);
use List::Util qw(max min);

my $input = read_file('input.txt');

$input =~ /seeds: ((?:\d+ ?)+)/;
my @seeds = split(' ', $1);

my @transitions;

my @separators = ('seed-to-soil map:', 'soil-to-fertilizer map:', 'fertilizer-to-water map:', 'water-to-light map:', 'light-to-temperature map:', 'temperature-to-humidity map:', 'humidity-to-location map:', '');
for my $i (0 .. $#separators - 1) {
  my ($s1, $s2) = ($separators[$i], $separators[$i + 1]);
  my ($match) = ($input =~ /$s1\n(.*)\n\n$s2/s);

  push @transitions, [map({ [split ' ', $_] } split('\n', $1))];
}

my $res = (1<<60);
my %memo;

sub dfs($start, $idx) {
  # say "$start $idx";
  if ($idx == @transitions) {
    $res = $start if $start < $res;
    return;
  }
  return if exists $memo{"$start $idx"};
  my $found = 0;
  for my $t (@{$transitions[$idx]}) {
    if ($t->[1] <= $start && $start < $t->[1] + $t->[2]) {
      dfs($t->[0] + ($start - $t->[1]), $idx + 1);
      $found = 1;
    }
  }
  dfs($start, $idx + 1) unless $found;
  $memo{"$start $idx"} = 1;
}

my ($minSeed, $maxSeed) = (1<<60, 0);
my @indexes;
for (my $i = 0; $i < @seeds; $i += 2) {
  $minSeed = min($minSeed, $seeds[$i]);
  $maxSeed = max($maxSeed, $seeds[$i] + $seeds[$i + 1] - 1);
  push @indexes, $i;
}
say "$minSeed $maxSeed";
for (my $i = $minSeed; $i <= $maxSeed; ++$i) {
  if (grep { $seeds[$_] <= $i && $i < $seeds[$_] + $seeds[$_ + 1]} @indexes) { 
    # say $i;
    dfs($i, 0);
  }
}
say $res;

