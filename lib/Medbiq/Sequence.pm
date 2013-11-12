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

package Medbiq::Sequence;

###########
# * Imports
###########

use 5.008;
use strict;
use warnings;
use version; our $VERSION = qv('0.0.1');
use utf8;
use Carp;
use Readonly;

use TUSK::Namespaces ':all';
use TUSK::Types;
use Types::Standard qw( Maybe ArrayRef HashRef );
use Medbiq::Types qw( NonNullString SequenceBlock );

#########
# * Setup
#########

use Moose;
with 'TUSK::XML::Object';

####################
# * Class attributes
####################

has school => (
    is => 'ro',
    isa => TUSK::Types::School,
    required => 1,
);

has events => (
    is => 'ro',
    isa => Medbiq::Types::Events,
    required => 1,
);

has Description => (
    is => 'ro',
    isa => Maybe[NonNullString],
    lazy => 1,
    builder => '_build_Description',
);

has SequenceBlock => (
    is => 'ro',
    isa => ArrayRef[SequenceBlock],
    lazy => 1,
    builder => '_build_SequenceBlock',
);

has _course_map => (
    is => 'ro',
    isa => HashRef,
    lazy => 1,
    builder => '_build__course_map',
);


############
# * Builders
############

sub _build_namespace { curriculum_inventory_ns }
sub _build_xml_content { [ qw( Description SequenceBlock ) ] }

sub _build_Description { return; }

sub _build_SequenceBlock {
    return [];
}

sub _build__course_map {
    my $self = shift;
    my %meetings_for;
    my @events = @{ $self->events->Event };
    foreach my $evt ( @events ) {
        my $meeting = $evt->dao;
        my $course = $meeting->course;
        my $course_id = $meeting->course_id;
        if (! exists $meetings_for{$course_id}) {
            $meetings_for{$course_id} = {
                course => $course,
                meetings => [],
            };
        }
        push @{ $meetings_for{$course_id}->{meetings} }, $meeting;
    }
    return \%meetings_for;
}

#################
# * Class methods
#################

###################
# * Private methods
###################

###########
# * Cleanup
###########

__PACKAGE__->meta->make_immutable;
no Moose;
1;

###########
# * Perldoc
###########

__END__

=head1 NAME

Medbiq::Sequence - A short description of the module's purpose

=head1 VERSION

This documentation refers to L<Medbiq::Sequence> v0.0.1.

=head1 SYNOPSIS

  use Medbiq::Sequence;

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head1 METHODS

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
