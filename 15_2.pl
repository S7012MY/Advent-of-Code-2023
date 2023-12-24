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
my @boxes;

sub processOperation($str) {
  my ($label, $sign, $num) = $str =~ qr/(\w+)(\=|-)(\d*)/;
  my $boxIdx = hashString($label);
  if ($sign eq '=') {
    if (my ($element) = grep { $_->{label} eq $label } @{$boxes[$boxIdx]}) {
      $element->{focal} = $num;
    } else {
      push @{$boxes[$boxIdx]}, { label => $label, focal => $num };
    }
  } else {
    my ($element) = grep { $_->{label} eq $label } @{$boxes[$boxIdx]};
    if ($element) {
      @{$boxes[$boxIdx]} = grep { $_->{label} ne $label } @{$boxes[$boxIdx]};
    }
  }
}

processOperation($_) for split /,/, $input;
my $res = 0;
for my $i (0 .. 255) {
  next unless defined $boxes[$i];
  for my $j (0 .. @{$boxes[$i]} - 1) {
    $res += ($i + 1) * ($j + 1) * $boxes[$i][$j]->{focal};
  }
}
say $res;