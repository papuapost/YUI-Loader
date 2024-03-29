use inc::Module::Install;

name     'YUI-Loader';
all_from 'lib/YUI/Loader.pm';
author   'Robert Krimen <rkrimen@cpan.org>';

resources repository => 'http://github.com/robertkrimen/yui-loader/tree/master';

{
    require ExtUtils::MakeMaker;
    use strict;
    no strict 'refs';

    my $libscan = \&{"ExtUtils::MM_Any::libscan"};
    *{"ExtUtils::MM_Any::libscan"} = sub {
        return '' unless $libscan->(@_);
        return '' if $_[1] =~ /\.sw[p-z]$/;
        return $_[1];
    };
}

{
    map { my ($pk, $vr) = split m/\s/; build_requires $pk => $vr || 0 } grep { ! /^\s*#/ } split m/\n/, <<_END_;
Test::Most
Directory::Scratch
_END_

    map { my ($pk, $vr) = split m/\s/; requires $pk => $vr || 0 } grep { ! /^\s*#/ } split m/\n/, <<_END_;
Algorithm::Dependency
Carp::Clan::Share
File::Copy
HTML::Declare
JSON 2.08
LWP::UserAgent
Moose
Path::Abstract
Path::Class
Scalar::Util
URI
_END_
}

if (-e 'inc/.author') {
    my $all_from = join '/', 'lib', split m/-/, name . '.pm';
    `perldoc -tF $all_from > README` if ! -e 'README' || (stat $all_from)[9] > (stat 'README')[9];
}

tests_recursive;

auto_install;

WriteAll;
