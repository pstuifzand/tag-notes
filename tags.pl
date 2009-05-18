#!/usr/bin/perl 

use strict;
use warnings;

print <<'HEAD';
<html>
<head>
<title>Notes</title>
<style>
.note {
    display:none;
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

while (<>) {
    my $note = $_;
    $note =~ s/\s+$//;

    my @tags = $note =~ m/#(\w+)/g;
    print "<p class='note " . join(' ',@tags) . q{'>} . $note . '</p>' . "\n";
}


print <<"FOOT";
</body>
</html>
FOOT


__END__

=head1 NAME

tags.pl - generate a HTML file for easy searching

=head1 DESCRIPTION

=head1 AUTHOR

Peter Stuifzand  peter.stuifzand@gmail.com

=cut

