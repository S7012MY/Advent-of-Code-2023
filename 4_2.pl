use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);
use List::Util qw(sum);

chomp (my $input = read_file('input.txt'));

my $sum = 0;
my $idx = 1;
my %copies;
for my $line (split '\n', $input) {
  ++$copies{$idx};
  my ($left, $right) = ($line =~ /Card +\d+: ((?: *\d+ *)+)\|((?: *\d+ *)+)/g);
  my %winning = map { $_ => 1 } split ' ', $left;
  my $res = sum(map({$winning{$_} // 0 } split(' ', $right)));
  for (1 .. $res) {
    $copies{$idx + $_} += $copies{$idx};
  }

  ++$idx;
}

say sum(values %copies);
# say Dumper \%copies;