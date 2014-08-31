use utf8;
package kdev::SchemaClass::ResultSet::Article;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub datesearch {
	my ( $self, $datetime) = @_;
	
	my $fdate = $self->result_source->schema->storage->datetime_parser->format_datetime($datetime);
	return $self->search({
		created_on => { '>' => $fdate },
		});	
	
}

1; 