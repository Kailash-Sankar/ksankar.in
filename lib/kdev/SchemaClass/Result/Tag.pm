use utf8;
package kdev::SchemaClass::Result::Tag;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

kdev::SchemaClass::Result::Tag

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<tags>

=cut

__PACKAGE__->table("tags");

=head1 ACCESSORS

=head2 tag_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 tagname

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 tagcolor

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "tag_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "tagname",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "tagcolor",
  { data_type => "varchar", is_nullable => 1, size => 20 },
);

=head1 PRIMARY KEY

=over 4

=item * L</tag_id>

=back

=cut

__PACKAGE__->set_primary_key("tag_id");

=head1 RELATIONS

=head2 tagmaps

Type: has_many

Related object: L<kdev::SchemaClass::Result::Tagmap>

=cut

__PACKAGE__->has_many(
  "tagmaps",
  "kdev::SchemaClass::Result::Tagmap",
  { "foreign.tag_id" => "self.tag_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-09-06 16:45:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yWJ6A/jgIRLsqTsFNIGCbA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
