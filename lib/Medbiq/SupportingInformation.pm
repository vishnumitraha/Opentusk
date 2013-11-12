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

package Medbiq::SupportingInformation;

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

use TUSK::Meta::Attribute::Trait::Namespaced;
use TUSK::Namespaces ':all';
use Types::Standard qw( Str );
use Types::XSD qw( AnyURI );
use TUSK::Types qw( XHTML_Object );

#########
# * Setup
#########

use Moose;
with 'TUSK::XML::Object';

####################
# * Class attributes
####################

has Link => (
    is => 'ro',
    isa => Maybe[AnyURI],
    lazy => 1,
    builder => '_build_Link',
);

has div => (
    traits => [ qw(Namespaced) ],
    is => 'ro',
    isa => Maybe[Str | XHTML_Object],
    lazy => 1,
    builder => '_build_div',
    namespace => xhtml_ns,
);


############
# * Builders
############

sub _build_namespace { competency_framework_ns }
sub _build_xml_content { [ qw( Link div ) ] }
sub _build_Link { return; }
sub _build_div { return; }

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

Medbiq::SupportingInformation - A short description of the module's purpose

=head1 VERSION

This documentation refers to L<Medbiq::SupportingInformation> v0.0.1.

=head1 SYNOPSIS

  use Medbiq::SupportingInformation;

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
