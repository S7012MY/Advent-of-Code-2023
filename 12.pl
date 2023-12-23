use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);

my $input = read_file('input.txt');
my @lines = split /\n/, $input;

sub getEncoding($pattern) {
  my @encoding;
  my $count = 0;
  $pattern .= ' ';
  for my $char (split //, $pattern) {
    if ($char eq '#') {
      ++$count;
    } else {
      push @encoding, $count if $count;
      $count = 0;
    }
  }
  return join ',', @encoding;
}

my $res = 0;
for my $line (@lines) {
  my ($pattern, $encoding) = split / /, $line;
  my $numQuestionMarks = () = $pattern =~ /(\?)/g;
  my $currentResult = 0;
  for (my $i = 0; $i < (1 << $numQuestionMarks); ++$i) {
    my $finalPattern;
    my $questionMarkIndex = 0;
    for (my $j = 0; $j < length($pattern); ++$j) {
      if (substr($pattern, $j, 1) eq '?') {
        $finalPattern .= ($i & (1 << $questionMarkIndex)) ? '#' : '.';
        ++$questionMarkIndex;
      } else {
        $finalPattern .= substr($pattern, $j, 1);
      }
    }
    ++$currentResult if getEncoding($finalPattern) eq $encoding;
  }
  $res += $currentResult;
}

say $res;