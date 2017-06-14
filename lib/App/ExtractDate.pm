package App::ExtractDate;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our %SPEC;

our $DATE_EXTRACT_MODULE = $ENV{PERL_DATE_EXTRACT_MODULE} // "Date::Extract::PERLANCAR";

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
        module => {
            summary => 'Date::Extract module to use',
            schema => 'perl::modname*',
            default => 'Date::Extract::PERLANCAR',
            cmdline_aliases => {m=>{}},
        },
    },
};
sub extract_date {
    my %args = @_;

    my $module = $args{module} // $DATE_EXTRACT_MODULE;
    $module = "Date::Extract::$module" unless $module =~ /::/;
    die "Invalid module '$module'" unless $module =~ /\A\w+(::\w+)*\z/;
    eval "use $module"; die if $@;
    my $parser = $module->new;

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

=head1 SYNOPSIS

 % ls | extract-date

 % ls | extract-date -m ID   ;# use Date::Extract::ID


=head1 ENVIRONMENT

=head2 PERL_DATE_EXTRACT_MODULE => str

Set default for C<module>.
