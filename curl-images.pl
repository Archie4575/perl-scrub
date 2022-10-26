#!/usr/bin/env perl
use strict;
use warnings;

# A perl script to read relative links from stdin, prepend domain and download images
# Reads relative links from stdin and downloads images to given directory
# by Archer Fabling <https://github.com/Archie4575>
# Version 1.0 26/10/202

# Usage:
# ./curl_images.pl [output_dir]
# Example:
# ./curl_images.pl < urls.txt
# Example with curl_resources.pl 
# cat data.csv | ./find_images.pl | uniq | ./curl_images.pl /var/www/assets/

# Arguments:
# outputdir     directory to download images to, defaults to ./images/

my $domain = "https://www.outbackmarine.com.au"

my $output_dir = "images";
if ($#ARGV+1 == 1) {
    $output_dir = $ARGV[0];
}

system("mkdir -p $output_dir 2>/dev/null");

my $count = 0;
foreach my $partial (<STDIN>) {
    
    my $full = "$domain$partial";
    print("Getting $full\n");
    system("cd $output_dir; curl -O $full");
    $count += 1;
}

