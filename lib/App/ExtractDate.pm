package App::ExtractDate;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our %SPEC;

$SPEC{extract_date} = {
    v => 1.1,
    summary => 'Extract date from lines of text',
    args => {
        input => {
            schema => ['array*', of=>'str*'],
            req => 1,
            pos => 0,
            cmdline_src => 'stdin_or_files',
            #stream => 1,
        },
        # XXX allow choosing which module to use, e.g. Date::Extract or
        # Date::Extract::Surprise etc.
    },
};
sub extract_date {
    require Date::Extract;

    my %args = @_;

    my $parser = Date::Extract->new;

    my $res = [];
    for my $line (@{$args{input}}) {
        chomp $line;
        my $dt = $parser->extract($line);
        push @$res, [$line, $dt ? "$dt" : undef];
    }

    [200, "OK", $res, {'table.fields' => ['orig', 'date']}];
}

1;
# ABSTRACT:
