#!/usr/bin/perl
use strict;
use Irssi;
use Irssi::Irc;
use vars qw($VERSION %IRSSI);

$VERSION = "1.0";
%IRSSI = (
    authors     =>      'Nathan Handler',
    contact     =>      'nhandler@ubuntu.com',
    name        =>      'devspot',
    description =>      'Easily Spot Developers on IRC in irssi',
    license     =>      'GPLv3+',
);

my %names = ();

sub reloadList {
    my $path = Irssi::settings_get_str('devspot_list');
    %names = ();
    open(NAMES, "<$path");
    my @NAMES = <NAMES>;
    close(NAMES);
    foreach my $line (@NAMES) {
        chomp $line;
        my($nick,$name) = split(/ /, $line,  2);
        $names{lc($nick)}=$name;
    }
}

sub isdev {
    my($data,$server,$witem) = @_;
    &reloadList();
    if($names{lc($data)}) {
        Irssi::active_win()->print("$data is a developer (" . $names{lc($data)} . ")");
    }
    else {
        Irssi::active_win()->print("$data is NOT a developer");
    }
}

Irssi::settings_add_str('devspot', 'devspot_list', '~/.irssi/devspot.list');
Irssi::command_bind('isdev', 'isdev');
