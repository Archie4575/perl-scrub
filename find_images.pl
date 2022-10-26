#!/usr/bin/env perl
use strict;
use warnings;

# A perl script to print relative links to images from outbackmarine 
# Reads csv from stdin and prints results to stdout
# by Archer Fabling <https://github.com/Archie4575>
# Version 1.0 26/10/202

# Usage: 
# ./find_images.pl < data.csv > urls.txt
# Usage with curl_resources.pl 
# cat data.csv | ./find_images.pl | ./curl_images.pl /var/www/assets/

# field indexes
my $desc_fid = 12; # 13th column

foreach my $line (<STDIN>) {
    
    my $desc = ( $line =~ /((?:[^,]*"[^"]*")*[^,]*)(?:,|$)/gm )[$desc_fid]; 
    my @hrefs = ( $desc =~ /<img.*?src="(?:https?:\/\/www\.outbackmarine\.com\.au)?(\/.*?)".*?>/gm );

    foreach my $href (@hrefs) {
        print("$href\n");
    }
}
