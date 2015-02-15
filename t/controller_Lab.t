use strict;
use warnings;
use Test::More;


use Catalyst::Test 'kdev';
use kdev::Controller::Lab;

ok( request('/lab')->is_success, 'Request should succeed' );
done_testing();
