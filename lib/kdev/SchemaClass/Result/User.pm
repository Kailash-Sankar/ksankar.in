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
  size: 8

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
  { data_type => "varchar", is_nullable => 0, size => 8 },
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


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-08-02 21:48:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3ebQd0YRwQ2ukGYaIWzblQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
