#!/usr/bin/perl 
# tag_watcher.pl - Watches the notes.txt file
# Copyright (C) 2009 Peter Stuifzand
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
