use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);
use List::Util qw(reduce);
use Math::BigInt;

my $input = read_file('input.txt');
my ($directions) = split '\n', $input;
my @matches = ($input =~ /(\w{3}) = \((\w{3}), (\w{3})\)/g);

my %sons;
for (my $i = 0; $i < @matches; $i += 3) {
  my ($parent, $son1, $son2) = @matches[$i .. $i + 2];
  $sons{$parent}{'L'} = $son1;
  $sons{$parent}{'R'} = $son2;
}

sub getFinishTime($node) {
  my $finishTime = 0;
  while (!($node =~ /\w\wZ/)) {
    my $dir = substr($directions, $finishTime % length($directions), 1);
    $node = $sons{$node}{$dir};
    ++$finishTime;
  }
  return $finishTime;
}

my $res = 1;
my @currentNodes = grep { $_ =~ /\w\wA/ } keys %sons;
# say $currentNodes[0] . " " . getFinishTime($currentNodes[0]);

my @finishTimes = map { getFinishTime($_) } @currentNodes;
my $res = reduce { Math::BigInt->blcm($a, $b) } @finishTimes;
say $res;