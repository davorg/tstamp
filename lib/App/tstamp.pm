use v5.38;
use feature 'class';
no warnings 'experimental::class';

class App::tstamp;

our $VERSION = '0.1.0';

use Time::Piece;
use Getopt::Long;
use File::Basename;

# use Moo;
# use Types::Standard qw[Bool Int Str];

field $utc :param = 0;
field $format :param = '%Y-%m-%dT%H:%M:%S';
field $pause :param = 0;

ADJUST {
  my ($help, $version);

  GetOptions(
      'format:s' => \$format,
      'pause:i' => \$pause,
      'utc' => \$utc,
      'help' => \$help,
      'version' => \$version,
    ) or die "\n";

    version() if $version;
    usage()   if $help;
}

method run {
  while (<>) {
    my $now = $utc ? gmtime : localtime;
    print $now->strftime($format) . ": $_";
    sleep $pause if $pause;
  }
}

sub version {
  my $me = basename $0;

  my $version = <<"END_OF_VERSION";

  $me version $VERSION

(Type "$me -h" for more help)

END_OF_VERSION

  print $version;
}

sub usage {

  my $me = basename $0;

  my $usage = <<"END_OF_USAGE";

  $me \[--format=<strftime_format>] [--utc] [--pause[=secs]] [--help] [--version]

* --format
  Define the format of the timestamp using a strftime-style
  format string. Default is '\%Y-\%m-\%dT\%H:\%M:\%S'.

* --utc
  Use UTC for the timestamp. Default is to use your local
  time zone.

* --pause
  Add a pause between lines in the output. Takes an optional number of seconds
  as an argument and defaults to one second.

* --help
  Display this help message.

* --version
  Display the current version.

END_OF_USAGE

  print $usage;
}

1;
