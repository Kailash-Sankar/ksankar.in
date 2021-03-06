use utf8;
package kdev::SchemaClass::Result::RecPass;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

kdev::SchemaClass::Result::RecPass

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

=head1 TABLE: C<rec_pass>

=cut

__PACKAGE__->table("rec_pass");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 saltedhash

  data_type: 'varchar'
  is_nullable: 0
  size: 64

=head2 salt

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 active

  data_type: 'integer'
  default_value: 1
  is_nullable: 1

=head2 type

  data_type: 'varchar'
  is_nullable: 0
  size: 10

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "saltedhash",
  { data_type => "varchar", is_nullable => 0, size => 64 },
  "salt",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "active",
  { data_type => "integer", default_value => 1, is_nullable => 1 },
  "type",
  { data_type => "varchar", is_nullable => 0, size => 10 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 user

Type: belongs_to

Related object: L<kdev::SchemaClass::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "kdev::SchemaClass::Result::User",
  { id => "user_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-09-14 16:12:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Nuim3odtieo93ArZdxg3pg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
