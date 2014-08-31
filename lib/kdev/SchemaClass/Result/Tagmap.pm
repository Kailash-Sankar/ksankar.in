use utf8;
package kdev::SchemaClass::Result::Tagmap;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

kdev::SchemaClass::Result::Tagmap

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

=head1 TABLE: C<tagmap>

=cut

__PACKAGE__->table("tagmap");

=head1 ACCESSORS

=head2 map_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 article_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 tag_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "map_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "article_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "tag_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</map_id>

=back

=cut

__PACKAGE__->set_primary_key("map_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<tag_id_unique>

=over 4

=item * L</tag_id>

=back

=cut

__PACKAGE__->add_unique_constraint("tag_id_unique", ["tag_id"]);

=head1 RELATIONS

=head2 article

Type: belongs_to

Related object: L<kdev::SchemaClass::Result::Article>

=cut

__PACKAGE__->belongs_to(
  "article",
  "kdev::SchemaClass::Result::Article",
  { id => "article_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 tag

Type: belongs_to

Related object: L<kdev::SchemaClass::Result::Tag>

=cut

__PACKAGE__->belongs_to(
  "tag",
  "kdev::SchemaClass::Result::Tag",
  { tag_id => "tag_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-08-31 17:18:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WEMnd5aQsz5bS8ppZS/9Ng


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
