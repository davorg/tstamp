package App::tstamp;

use strict;
use warnings;

use Time::Piece;
use Getopt::Long;
use File::Basename;

use Moo;
use Types::Standard qw[Bool Int Str];

our $VERSION = '0.0.2';

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

has pause => (
  is => 'ro',
  isa => Int,
  default => sub { 0 },
  required => 1,
);

around BUILDARGS => sub {
  my ($orig, $class, @args) = @_;

  if (@args) {
    return $class->$orig(@args);
  } else {
    my %opts;

    GetOptions(
      \%opts,
      'format:s',
      'pause:i',
      'utc',
      'help',
      'version',
    ) or die "\n";

    version() if $opts{version};
    usage()   if $opts{help};

    exit 0    if $opts{version} || $opts{help};

    delete @opts{qw[version help]};

    my $obj = {};
    for (keys %opts) {
      $obj->{$_} = $opts{$_} if defined $opts{$_};
    }

    return $class->$orig($obj);
  }
};

sub run {
  my $self = shift;

  while (<>) {
    my $now = $self->utc ? gmtime : localtime;
    print $now->strftime($self->format) . ": $_";
    sleep $self->pause if $self->pause;
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
