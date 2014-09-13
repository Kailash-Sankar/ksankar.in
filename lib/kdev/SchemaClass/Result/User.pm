use utf8;
package kdev::SchemaClass::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

kdev::SchemaClass::Result::User

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

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 username

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 password

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 email

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 active

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 firstname

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 lastname

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 role

  data_type: 'integer'
  default_value: 1
  is_nullable: 1

=head2 dob

  data_type: 'varchar'
  is_nullable: 0
  size: 10

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "username",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "password",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "email",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "active",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "firstname",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "lastname",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "role",
  { data_type => "integer", default_value => 1, is_nullable => 1 },
  "dob",
  { data_type => "varchar", is_nullable => 0, size => 10 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<username_unique>

=over 4

=item * L</username>

=back

=cut

__PACKAGE__->add_unique_constraint("username_unique", ["username"]);

=head1 RELATIONS

=head2 articles

Type: has_many

Related object: L<kdev::SchemaClass::Result::Article>

=cut

__PACKAGE__->has_many(
  "articles",
  "kdev::SchemaClass::Result::Article",
  { "foreign.author_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 comments

Type: has_many

Related object: L<kdev::SchemaClass::Result::Comment>

=cut

__PACKAGE__->has_many(
  "comments",
  "kdev::SchemaClass::Result::Comment",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 rec_passes

Type: has_many

Related object: L<kdev::SchemaClass::Result::RecPass>

=cut

__PACKAGE__->has_many(
  "rec_passes",
  "kdev::SchemaClass::Result::RecPass",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-09-13 22:08:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Q+AZ5CTNjdUvK0dHsYNKDA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
