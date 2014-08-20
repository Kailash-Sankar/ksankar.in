use strict;
use warnings;
use Test::More;


use Catalyst::Test 'kdev';
use kdev::Controller::Userbase;

ok( request('/userbase')->is_success, 'Request should succeed' );
done_testing();
