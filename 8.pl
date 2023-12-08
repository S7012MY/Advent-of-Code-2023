use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);

my $input = read_file('input.txt');
my ($directions) = split '\n', $input;
my @matches = ($input =~ /(\w{3}) = \((\w{3}), (\w{3})\)/g);

my %sons;
for (my $i = 0; $i < @matches; $i += 3) {
  my ($parent, $son1, $son2) = @matches[$i .. $i + 2];
  $sons{$parent}{'L'} = $son1;
  $sons{$parent}{'R'} = $son2;
}

my $idx = 0;
my $currentNode = 'AAA';
while (1) {
  # say $currentNode;
  last if $currentNode eq 'ZZZ';
  my $dir = substr($directions, $idx % length($directions), 1);
  $currentNode = $sons{$currentNode}{$dir};
  ++$idx;
}

say $idx;