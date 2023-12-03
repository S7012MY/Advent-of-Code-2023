use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);

chomp (my $input = read_file('input.txt'));
my $id = 1;
my $sum = 0;
for my $line (split /\n/, $input) {
  my @matches = ($line =~ /((?:\d+ (?:blue|red|green)(?:, )?){1,3}(?:; )?)/g);
  my $ok = 1;
  for my $match (@matches) {
    my ($green) = ($match =~ /(\d+) green/g);
    my ($red) = ($match =~ /(\d+) red/g);
    my ($blue) = ($match =~ /(\d+) blue/g);

    if ($green > 13 || $red > 12 || $blue > 14) {
      $ok = 0;
      last;
    }
  }
  $sum += $id if $ok;
  ++$id;
}

say $sum;