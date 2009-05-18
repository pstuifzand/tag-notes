#!/usr/bin/perl 

use strict;
use warnings;

use Linux::Inotify2;

# create a new object
my $inotify = Linux::Inotify2->new()
    or die "unable to create new inotify object: $!";

$inotify->watch('/home/peter/work/tags/notes.txt', IN_MODIFY, \&watch_callback);

1 while $inotify->poll;

sub watch_callback {
    my $e = shift;
    print "File changed\n";

    my $name = $e->fullname;
    print "$name was accessed\n" if $e->IN_ACCESS;
    print "$name is no longer mounted\n" if $e->IN_UNMOUNT;
    print "$name is gone\n" if $e->IN_IGNORED;
    print "events for $name have been lost\n" if $e->IN_Q_OVERFLOW;

    system("perl tags.pl <notes.txt >notes.html");

    $inotify->watch('/home/peter/work/tags/notes.txt', IN_MODIFY, \&watch_callback);
    return;
}
