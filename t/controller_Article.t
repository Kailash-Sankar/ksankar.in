use strict;
use warnings;
use Test::More;


use Catalyst::Test 'kdev';
use kdev::Controller::Article;

ok( request('/article')->is_success, 'Request should succeed' );
done_testing();
