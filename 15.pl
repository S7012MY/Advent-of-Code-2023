use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);
use List::Util qw(sum);

my $input = read_file('input.txt');

sub hashString($str) {
  my $res = 0;
  for my $c (split //, $str) {
    $res += ord($c);
    $res *= 17;
    $res %= 256;
  }
  return $res;
}

say sum map { hashString($_) } split /,/, $input;