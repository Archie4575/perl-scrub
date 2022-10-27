#!/usr/bin/env perl
use strict;
use warnings;

# A perl script to scrub links to outbackmarine from exported csv file
# Reads from stdin, prints verbose logs to stderr and prints new csv file to stdout
# by Archer Fabling <https://github.com/Archie4575>
# Version 1.1 26/10/2022
#
# Usage: 
# ./scrub-links.pl < old.csv > new.csv
# or to print tidy html and read in colour:
# ./scrub-links.pl < old.csv > new.csv 2> log.html && bat log.html
# note: requires tidy and bat
#
# Options:
# -t    tidy html flag. requires tidy

use Getopt::Std;

my %opts = ('t', 0);
getopts('t', \%opts);

# field indexes
my $desc_fid = 7; # 8th column
my $name_fid = 0; # 1st column

foreach my $line (<STDIN>) {
    
    my @parts = ( $line =~ /((?:[^,"]*"[^"]*")*[^,]*)(?:,|$)/gm ); 
    my $desc = $parts[$desc_fid];
    my $name = $parts[$name_fid];

    say STDERR "<!--- Editing $name --->";
    say STDERR "<!--- BEFORE --->";
    print_html($desc, $opts{'t'});

    $line =~ s|<a.*?href='(?:https?://www\.outbackmarine\.com\.au\|/).*?'.*?>(.*?)</a>|$1|g;
    $line =~ s|(<img.*?src=')(?:https?://www\.outbackmarine\.com\.au)?(.*?'.*?>)|$1$2|g;

    say STDERR "<!--- AFTER --->";
    $desc = ( $line =~ /((?:[^,"]*"[^"]*")*[^,]*)(?:,|$)/gm )[$desc_fid]; 
    print_html($desc, $opts{'t'});

    print $line;
}

sub print_html {
    my $desc = $_[0];
    if ($_[1] == 0) {
        say STDERR $desc;
    } else {
        system("echo $desc | \
            tidy -indent --indent-spaces 4 -quiet --tidy-mark no -f /dev/null - >&2");
    }
}
