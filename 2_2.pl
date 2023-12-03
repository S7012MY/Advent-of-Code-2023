use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);

chomp (my $input = read_file('input.txt'));

my $sum = 0;
for my $line (split /\n/, $input) {
  my @matches = ($line =~ /((?:\d+ (?:blue|red|green)(?:, )?){1,3}(?:; )?)/g);
  my $ok = 1;
  my ($maxGreen, $maxRed, $maxBlue) = (0, 0, 0);
  for my $match (@matches) {
    my ($green) = ($match =~ /(\d+) green/g);
    my ($red) = ($match =~ /(\d+) red/g);
    my ($blue) = ($match =~ /(\d+) blue/g);

    $maxGreen = $green if $green > $maxGreen;
    $maxRed = $red if $red > $maxRed;
    $maxBlue = $blue if $blue > $maxBlue;
  }
  # say "$line $minGreen $minRed $minBlue"
  $sum += ($maxGreen * $maxRed * $maxBlue);
}

say $sum;