#!/usr/bin/perl 
# tags.pl - Generate a HTML file with linked tags
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

print <<'HEAD';
<html>
<head>
<title>Notes</title>
<style>
.note {
    width: 600px;
}
</style>
<script src="jquery-1.3.2.min.js"></script>
<script>
function show_notes(tagstr) {
    if (tagstr.match(/^\s*$/)) {
        $('.note').show();
        return;
    }
    $('.note').hide();

    var tags = tagstr.split(/\s+/);
    var selector = '';

    for (var tag in tags) {
        selector += '.' + tags[tag];
    }

    $(selector).show();
}
</script>

</head>
<body>
    <form onsubmit="return false">
        <input type='text' name='tags' id='tags'>
        <button type="submit" onclick="show_notes($('#tags').val())">Show</button>
    </form>
HEAD

local $/ = '';

my @all_tags;
while (<>) {
    my $note = $_;
    $note =~ s/\s+$//;

    my @tags = $note =~ m/#(\w+)/g;

    $note =~ s{#(\w+)}{<a href="#" onclick="show_notes('$1')">#$1</a> }g;

    print "<p class='note " . join(' ',@tags) . q{'>} . $note . '</p>' . "\n";

    push @all_tags, @tags;
}

my %tags;
for my $tag (@all_tags) {
    $tags{$tag}++;
}

for my $tag (sort keys %tags) {
    print qq{<a href="#" onclick="show_notes('$tag')">$tag</a> };
}

print <<"FOOT";
</body>
</html>
FOOT
__END__

=head1 NAME

tags.pl - generate a HTML file for easy searching

=head1 DESCRIPTION

=head1 WEBSITE

The newest version of this program can be found at:
http://github.com/pstuifzand/tag-notes

=head1 AUTHOR

Peter Stuifzand  peter.stuifzand@gmail.com

=cut

