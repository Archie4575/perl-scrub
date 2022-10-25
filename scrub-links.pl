#!/usr/bin/env perl
use warnings;

use Getopt::Std;

%opts = ('t', 0);
getopts('t', \%opts);

# field indexes
my $desc_fid = 12; # 13th column
my $name_fid = 4;  #  5th column

foreach my $line (<STDIN>) {
    
    my @parts = ( $line =~ /((?:[^,]*"[^"]*")*[^,]*)(?:,|$)/gm ); 
    my $desc = $parts[$desc_fid];
    my $name = $parts[$name_fid];

    say STDERR "<!--- Editing $name --->";
    say STDERR "<!--- BEFORE --->";
    print_html($desc, $opts{'t'});

    $line =~ s|<a.*?href="(?:https?://www\.outbackmarine\.com\.au\|/).*?".*?>(.*?)</a>|$1|g;
    $line =~ s|(<img.*?src=")(?:https?://www\.outbackmarine\.com\.au)?(.*?".*?>)|$1$2|g;

    say STDERR "<!--- AFTER --->";
    $desc = ( $line =~ /((?:[^,]*"[^"]*")*[^,]*)(?:,|$)/gm )[$desc_fid]; 
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
