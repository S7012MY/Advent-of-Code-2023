use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);
use List::Util qw(max min);

my $input = read_file('input.txt');

my @card_order = ('A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2');
@card_order = reverse @card_order;

sub compare_cards($a, $b) {
  my $a_index = index join('', @card_order), $a;
  my $b_index = index join('', @card_order), $b;
  return $a_index <=> $b_index;
}

sub compare_card_indexses($a, $b) {
  my @a_cards = split '', $a;
  my @b_cards = split '', $b;
  for my $i (0 .. $#a_cards) {
    my $res = compare_cards($a_cards[$i], $b_cards[$i]);
    return $res if $res != 0;
  }
  return 0;
}

sub hand_type($cards) {
  my %freq;
  for my $card (split('', $cards)) {
    ++$freq{$card};
  }
  return 7 if keys %freq == 1;
  return 6 if keys %freq == 2 && max(values %freq) == 4;
  return 5 if keys %freq == 2 && max(values %freq) == 3;
  return 4 if keys %freq == 3 && max(values %freq) == 3;
  return 3 if keys %freq == 3 && max(values %freq) == 2;
  return 2 if keys %freq == 4;
  return 1;
}

my @plays = map { [split ' ', $_] } split('\n', $input);

sub cmp_hands($a, $b) {
  my ($a1, $a2) = ($a->[0], $a->[1]);
  my ($b1, $b2) = ($b->[0], $b->[1]);
  my $res = hand_type($a1) <=> hand_type($b1);
  return $res if $res != 0;
  return compare_card_indexses($a1, $b1);
}

my @res = sort { cmp_hands($a, $b) } @plays;
# my @res = @plays;
my $total = 0;
for my $i (0 .. $#res) {
  # say "$i: $res[$i][0] $res[$i][1] " . hand_type($res[$i][0]);
  $total += $res[$i][1] * ($i + 1);
}
say $total;