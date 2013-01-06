#!/usr/bin/perl
# @author Johan Sydseter, <johan.sydseter@startsiden.no>
# @author Thomas Malt, <thomas.malt@startsiden.no>

# Feature steps for verifying that a debian package is installed

use strict;
use warnings;

use Test::More;
use Test::BDD::Cucumber::StepFile;
use Method::Signatures;
use Data::Dump;

##
# Scenario: Check that the right debian packages are installed
##

# Verify that all necessary packages is installed
When qr/this debian "(.+)"/, func ($c) {
    my $package = $1;
    ok(has_installed_package($package), "Verify that the '". $package . "' is installed");
};


# Verify that all necessary modules is made available to the perl environment
Then qr/this perl "(.+)"/, func ($c) {
    use_ok($1);
};

##
# Scenario: Check that novus files and directories exists in their right 
# locations across the system
##
Given qr/this novus "(.+)"/, func ($c) {
    $c->stash->{scenario}->{filename} = $1;
};

# Verify that all necessary scripts are present on the system
Then qr/this can be found in this system "(.+)"/, func ($c) {
    my $directory = $1;
    my $filename  = $c->stash->{scenario}->{filename};

    ok(-d $directory, "Verify the directory |$directory| exist first");
    ok(-f "$directory/$filename", "Verify the file |$filename| exists");
};

# confirm that a certain package is installed.
sub has_installed_package {
    my ($package) = @_;

    my $print_arg = '$2';
    my $status = qx(dpkg --get-selections $package | awk '{print $print_arg}');
    chomp $status;

    return 1 if $status eq 'install';

    return undef;
}

