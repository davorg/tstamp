package App::tstamp;

use strict;
use warnings;

use Time::Piece;
use Getopt::Long;
use File::Basename;

use Moo;
use Types::Standard qw[Bool Str];

our $VERSION = '0.0.1';

has utc => (
  is => 'ro',
  isa => Bool,
  default => sub { 0 },
  required => 1,
);

has format => (
  is => 'ro',
  isa => Str,
  default => sub { '%Y-%m-%dT%H:%M:%S' },
  required => 1,
);

around BUILDARGS => sub {
  my ($orig, $class, @args) = @_;

  GetOptions(
    'format:s' => \(my $format),
    'utc'      => \(my $utc),
    'help'     => \(my $help),
    'version'  => \(my $version),
  );

  version() if $version;
  usage()   if $help;

  return $class->$orig({
    utc => $utc,
    format => $format,
  });
};

sub run {
  my $self = shift;

  while (<>) {
    my $now = $self->utc ? gmtime : localtime;
    print $now->strftime($self->format) . ": $_";
  }
}

sub version {
  my $me = basename $0;

  my $version = <<"END_OF_VERSION";

  $me version $VERSION

(Type "$me -h" for more help)

END_OF_VERSION

  print $version;

  exit 0;
}

sub usage {

  my $me = basename $0;

  my $usage = <<"END_OF_USAGE";

  $me \[--format=<strftime_format>] [--utc] [--help]

* --format
  Define the format of the timestamp using a strftime-style
  format string. Default is '\%Y-\%m-\%dT\%H:\%M:\%S'.

* --utc
  Use UTC for the timestamp. Default is to use your local
  time zone.

* --help
  Display this help message.

END_OF_USAGE

  print $usage;

  exit 0;
}

1;
