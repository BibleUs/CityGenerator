#!/usr/bin/perl -wT
###############################################################################

package ContinentGenerator;

use strict;
use warnings;
use vars qw(@ISA @EXPORT_OK $VERSION $XS_VERSION $TESTING_PERL_ONLY);
use base qw(Exporter);
@EXPORT_OK = qw( create_continent generate_continent_name);

###############################################################################

=head1 NAME

    ContinentGenerator - used to generate Continents

=head1 SYNOPSIS

    use ContinentGenerator;
    my $continent=ContinentGenerator::create_continent();

=cut

###############################################################################

use Carp;
use CGI;
use Data::Dumper;
use Exporter;
use GenericGenerator qw(set_seed rand_from_array roll_from_array d parse_object seed);
use NPCGenerator;
use List::Util 'shuffle', 'min', 'max';
use POSIX;
use version;
use XML::Simple;

my $xml = XML::Simple->new();
local $ENV{XML_SIMPLE_PREFERRED_PARSER} = 'XML::Parser';

###############################################################################

=head1 CONFIGURATION AND ENVIRONMENT

=head2 Data files

The following datafiles are used by ContinentGenerator.pm:

=over

=item F<xml/data.xml>

=item F<xml/continentnames.xml>

=back

=head1 INTERFACE


=cut

###############################################################################
my $xml_data            = $xml->XMLin( "xml/data.xml",           ForceContent => 1, ForceArray => ['option'] );
my $continentnames_data = $xml->XMLin( "xml/continentnames.xml", ForceContent => 1, ForceArray => ['option'] );

###############################################################################

=head2 Core Methods

The following methods are used to create the core of the continent structure.


=head3 create_continent()

This method is used to create a simple continent with nothing more than:

=over

=item * a seed

=item * a name

=back

=cut

###############################################################################
sub create_continent {
    my ($params) = @_;
    my $continent = {};

    if ( ref $params eq 'HASH' ) {
        foreach my $key ( sort keys %$params ) {
            $continent->{$key} = $params->{$key};
        }
    }

    if ( !defined $continent->{'seed'} ) {
        $continent->{'seed'} = set_seed();
    }

    # This knocks off the city IDs
    $continent->{'seed'} = $continent->{'seed'} - $continent->{'seed'} % 100;

    generate_continent_name($continent);

    return $continent;
} ## end sub create_continent


###############################################################################

=head3 generate_continent_name()

    generate a name for the continent.

=cut

###############################################################################
sub generate_continent_name {
    my ($continent) = @_;
    set_seed( $continent->{'seed'} );
    my $nameobj = parse_object($continentnames_data);
    $continent->{'name'} = $nameobj->{'content'} if ( !defined $continent->{'name'} );
    return $continent;
}


1;

__END__


=head1 AUTHOR

Jesse Morgan (morgajel)  C<< <morgajel@gmail.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2013, Jesse Morgan (morgajel) C<< <morgajel@gmail.com> >>. All rights reserved.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation version 2
of the License.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

=head1 DISCLAIMER OF WARRANTY

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

=cut
