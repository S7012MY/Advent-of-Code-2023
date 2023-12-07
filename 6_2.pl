use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);

sub lb($time, $distance) {
  my ($l, $r) = (0, $time);
  while ($l < $r) {
    my $m = int(($l + $r) / 2);
    if ($m * ($time - $m) > $distance) {
      $r = $m;
    } else {
      $l = $m + 1;
    }
  }
  return $l
}

sub ub($time, $distance) {
  my ($l, $r) = (0, $time);
  while ($l < $r) {
    my $m = int(($l + $r + 1) / 2);
    if ($m * ($time - $m) > $distance) {
      $l = $m;
    } else {
      $r = $m - 1;
    }
  }
  return $l
}

chomp (my $input = read_file('input.txt'));
$input =~ s/ +//g;
my ($time, $distance) = split '\n', $input;
$time =~ s/Time://g;
$distance =~ s/Distance://g;
say ub($time, $distance) - lb($time, $distance) + 1;


