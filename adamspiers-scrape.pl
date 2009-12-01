#!/usr/bin/perl

use strict;
use warnings;
use LWP::Simple;
use autodie qw( open close get );

# Base url of the adam's cvsweb repository
my $basename = 'http://adamspiers.org/cgi-bin/cvsweb.cgi/';
# Module to check out
my $modulename = "config/shell-env/";

sub fetchdir {
  my ($basename, $module, $dir) = @_;
  my $page = get($basename . $module . $dir);

  mkdir $dir;

  #print "page: $page";
  my $piece = "";
  if ($page =~ /Parent\s+Directory(.*)Show only/sxm) {
    $piece = $1;
  } elsif ($page =~ /Parent\s+Directory(.*)FreeB/sxm) {
    $piece = $1;
  } else {
    die "Invalid page: $page\n";
  }
  while ($piece =~ /a\s+href="\.\/([^"]+)">.*[^>]<\/a><\/td>/gxm) {
    my $nodename = $1;
    print "Getting $nodename ";
    if ($nodename =~ /Attic/xm) {
    } elsif ($nodename =~ /\/$/xm) {
      print "(directory)\n";
      fetchdir ($basename, $module, "$dir$nodename");
    } else {
      print "\n";
      my $fileurl = $basename . "~checkout~/" . $module . $dir . $nodename;
      my $file = get ($fileurl);
      open my $outfh, q{>}, "$dir$nodename";
      print {$outfh} $file;
      close $outfh;
    }
  }
}

fetchdir ($basename, $modulename, '');
