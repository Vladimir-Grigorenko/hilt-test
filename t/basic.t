use Mojo::Base -strict;

use strict;
use warnings;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('HiltTest');

$t->app->log->level('debug');

#$t->post_ok('/users/add' => form => { mail => 'test_test@test.com', first_name => 'Test first name', last_name => 'Test last name', address => 'test address' })->status_is(200)->json_has( '/success' );

$t->get_ok('/users/list' => json => { page => 1, limit => 20, sort => {user_id => 'DESC'}})->status_is(200)->json_has( '/success' );

#$t->put_ok('/users/1' => form => { mail => 'update@test.com', first_name => 'Update first name', last_name => 'Update last name', address => 'Update' })->status_is(200)->json_has( '/success' );

#$t->delete_ok('/users/1')->status_is(200)->json_has( '/success' );

done_testing();
