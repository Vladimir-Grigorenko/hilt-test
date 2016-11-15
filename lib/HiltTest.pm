package HiltTest;

use strict;
use warnings;

use Mojo::Base 'Mojolicious';
use Mojo::Log;

use HiltTest::Schema;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');
  
  my $schema = HiltTest::Schema->connect('dbi:mysql:database=hilt_test','root','MySQL@');
  $self->helper(db => sub {return $schema});
  
  $self->log(
        Mojo::Log->new(
            path    => '../log/debug.log',
            level   => 'debug'
        )
    );

  # Router
  my $r = $self->routes;
  
  # Normal route to controller
  $r->get('/')->to('example#welcome');

  $r->get('/users/list')->to('example#list_users');
  $r->post('/users/add')->to('example#add_user');
  $r->delete('/users/:id')->to('example#delete_user');
  $r->put('/users/:id')->to('example#update_user');


}

1;
