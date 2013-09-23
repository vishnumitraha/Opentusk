# Copyright 2013 Tufts University
#
# Licensed under the Educational Community License, Version 1.0 (the
# "License"); you may not use this file except in compliance with the
# License. You may obtain a copy of the License at
#
# http://www.opensource.org/licenses/ecl1.php
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package TUSK::Medbiq::CurriculumInventory;

use 5.008;
use strict;
use warnings;
use version;
use utf8;
use Carp;
use Readonly;

use MooseX::Types::Moose qw(Str);
use TUSK::Types qw(School Medbiq_UniqueID Medbiq_Institution);
use TUSK::Medbiq::UniqueID;
use TUSK::Medbiq::Institution;
use TUSK::Medbiq::Program;

use Moose;

with 'TUSK::XML::RootObject';

our $VERSION = qv('0.0.1');

####################
# Class attributes #
####################

has school => (
    is => 'ro',
    isa => School,
    coerce => 1,
    required => 1,
);

has schemaLocation => (
    traits => [qw/Namespaced/],
    is => 'ro',
    isa => Str,
    lazy => 1,
    builder => '_build_schemaLocation',
    namespace => 'http://www.w3.org/2001/XMLSchema-instance',
);

has ReportID => (
    is => 'ro',
    isa => Medbiq_UniqueID,
    lazy => 1,
    builder => '_build_ReportID',
);

has Institution => (
    is => 'ro',
    isa => Medbiq_Institution,
    lazy => 1,
    builder => '_build_Institution',
);

has Program => (
    is => 'ro',
    isa => 'TUSK::Medbiq::Program',
    lazy => 1,
    builder => '_build_Program',
);

#################
# Class methods #
#################

###################
# Private methods #
###################

sub _build_namespace { 'http://ns.medbiq.org/curriculuminventory/v1/' }
sub _build_tagName { 'CurriculumInventory' }
sub _build_xml_content { [ qw( ReportID Institution Program ) ] }
sub _build_xml_attributes { [ qw( schemaLocation ) ] }

sub _build_schemaLocation {
    return 'http://ns.medbiq.org/curriculuminventory/v1/curriculuminventory.xsd';
}

sub _build_ReportID {
    return TUSK::Medbiq::UniqueID->new;
}

sub _build_Institution {
    return TUSK::Medbiq::Institution->new;
}

sub _build_Program {
    my $self = shift;
    my $name = $self->school->getSchoolName . ' Degree Program';
    return TUSK::Medbiq::Program->new( ProgramName => $name );
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

__END__

=head1 NAME

TUSK::Medbiq::CurriculumInventory - Container object for a curriculum
inventory report

=head1 VERSION

This documentation refers to L<TUSK::Medbiq::CurriculumInventory> v0.0.1.

=head1 SYNOPSIS

  use XML::Writer;
  use TUSK::Medbiq::CurriculumInventory;
  my $ci = TUSK::Medbiq::CurriculumInventory->new( school => 'Default' );
  my $writer = XML::Writer->new;
  $ci->write_xml($writer);

=head1 DESCRIPTION

Given a L<TUSK::Core::School> object, L<TUSK::Medbiq::CurriculumInventory>
will contain the necessary information for a curriculum inventory
report.

This object is meant to be constructed by L<TUSK::Medbiq::Report>.

See the Medbiquitous curriculum inventory specification at
L<http://ns.medbiq.org/curriculuminventory/v1/> for more information.

=head1 ATTRIBUTES

=over 4

=item school

A required attribute of type L<TUSK::Medbiq::Types>::School.

=back

=head1 METHODS

=over 4

=item write_xml

Output a curriculum inventory document to the L<XML::Writer> input
parameter.

=back

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

TUSK modules depend on properly set constants in the configuration
file loaded by L<TUSK::Constants>. See the documentation for
L<TUSK::Constants> for more detail.

=head1 INCOMPATIBILITIES

This module has no known incompatibilities.

=head1 BUGS AND LIMITATIONS

There are no known bugs in this module. Please report problems to the
TUSK development team (tusk@tufts.edu) Patches are welcome.

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Tufts University

Licensed under the Educational Community License, Version 1.0 (the
"License"); you may not use this file except in compliance with the
License. You may obtain a copy of the License at

http://www.opensource.org/licenses/ecl1.php

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
