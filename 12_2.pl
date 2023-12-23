# numWays[idxPattern][idxEncoding][cons] = number of ways to encode characters
#    from 0 to idxPattern (inclusive) that match the encoding from 0 to idxEncoding
#    having cons consecutive '#' characters at the end of the pattern

use v5.36;
use Data::Dumper;
use File::Slurp qw(read_file);

my $input = read_file('input.txt');
my @lines = split /\n/, $input;

my $res = 0;
for my $line (@lines) {
  my ($pattern, $encoding) = split / /, $line;
  $pattern = "$pattern?$pattern?$pattern?$pattern?$pattern";
  $encoding = "$encoding,$encoding,$encoding,$encoding,$encoding";

  $pattern = ' ' . $pattern . '.';
  my @encoding = split /,/, $encoding;
  @encoding = (1, @encoding);
  my %numWays;
  $numWays{0}{0}{0} = 1;
  for my $idxPattern (1 .. length($pattern) - 1) {
    my $char = substr($pattern, $idxPattern, 1);
    # if $char is '#', $cons increases by 1
    # if $char is '.', $cons will be 0, but we can come from any previous $cons
    #   and we will go to a new $idxEncoding
    # if $char is '?', we can have the above two cases
    for my $idxEncoding (0 .. @encoding - 1) {
      if ($char eq '#' || $char eq '?') {
        for my $cons (0 .. $encoding[$idxEncoding + 1] // 0) {
          $numWays{$idxPattern}{$idxEncoding}{$cons} += $numWays{$idxPattern - 1}{$idxEncoding}{$cons - 1} // 0;
        }
      }
      if ($char eq '.' || $char eq '?') {
        $numWays{$idxPattern}{$idxEncoding}{0} += $numWays{$idxPattern - 1}{$idxEncoding}{0} // 0;
        $numWays{$idxPattern}{$idxEncoding}{0} += $numWays{$idxPattern - 1}{$idxEncoding - 1}{$encoding[$idxEncoding]} // 0;
      }
    }
  }
  $res += $numWays{length($pattern) - 1}{@encoding - 1}{0};
}

say $res;