use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);
use List::Util qw(max min);

my $input = read_file('example.txt');

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

sub range_intersect($a1, $a2, $b1, $b2) {
  return 0 if $a2 < $b1 || $b2 < $a1;
  return 1;
}

sub range_intersection($a, $b, $x, $y) {
  return (max($a, $x), min($b, $y));
}

sub dfs($start, $end, $idx) {
  say "$start $end $idx";
  if ($idx == @transitions) {
    $res = $start if $start < $res;
    return;
  }

  for my $t (@{$transitions[$idx]}) {
    my ($a, $b) = ($t->[1], $t->[1] + $t->[2] - 1);
    if (range_intersect($start, $end, $a, $b)) {
      my ($ia, $ib) = range_intersection($start, $end, $a, $b);
      my $len = $ib - $ia + 1;
      my $new_start = $ia - ($t->[1] - $t->[0]);
      dfs($new_start, $new_start + $len - 1, $idx + 1);
    }
    dfs($start, min($end, $a - 1), $idx + 1) if ($start < $a);
    dfs(max($start, $b + 1), $end, $idx + 1) if ($b < $end);
  }
}

# for (my $i = 0; $i < @seeds; $i += 2) {
#   dfs($seeds[$i], $seeds[$i] + $seeds[$i + 1] - 1, 0);
# }
dfs(79, 79 + 13, 0);
say $res;