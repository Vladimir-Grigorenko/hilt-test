package HiltTest::Controller::Example;

use strict;
use warnings;

use HTTP::Status qw(:constants);
use Mojo::Base 'Mojolicious::Controller';

use Try::Tiny;
use JSON;
use DBIx::Class::ResultClass::HashRefInflator;

# This action will render a template
sub welcome {
  my $self = shift;

  # Render template "example/welcome.html.ep" with message
  $self->render(msg => 'Welcome to the Mojolicious real-time web framework!');
}

sub list_users {
  my $self = shift;
  my $req_info = $self->req->json;
  my $rs;
  my $data = [];
  
  try {
    
    $rs = $self->db->resultset('User')->search(undef, $req_info);
      
    #$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
    
    $rs->all();
    
    while (my $row = $rs->next() ) {
      push @{$data}, $row;
    }
        
    $data = JSON->new->utf8->encode($data);
    
    my $json = {
      success => 'true',
      data => $data,
    };
    
    use Data::Dumper;
    
    $self->app->log->debug('Dump data = ' . Dumper $data);
    $self->app->log->debug('Dump req_info = ' . Dumper $req_info);

    return $self->render(json => $json, status => HTTP_OK);    

  } catch {
    
    $self->app->log->debug("caught error: $_");
    my $json_error = {
      failue => 'true',
      errstr => 'Errors were got data to list users',
    };
    
    return $self->render(json => $json_error, status => HTTP_UNPROCESSABLE_ENTITY);    
  
  };
    
}

sub add_user {
  my $self = shift;
  my $mail = $self->param('mail');
  my $first_name = $self->param('first_name');
  my $last_name = $self->param('last_name');
  my $address = $self->param('address');
  
  my $rs = $self->db->resultset('User');
  
  my $data = $rs->create({
    mail => $mail,
    first_name => $first_name,
    last_name => $last_name,
    address => $address,
  });
  
  unless ( $data ) {
    my $json_error = {
      failue => 'true',
      errstr => 'Error add user',
    };
    
  return $self->render(json => $json_error);
  }
  
  my $json = {
    success => 'true',
    data => $data,
  };
  
  return $self->render(json => $json);
}

sub delete_user {
  my $self = shift;
  my $user_id = $self->param('id') || 0;

  my $rs = $self->db->resultset('User');

  my $data = $rs->search({ user_id => $user_id })->delete;
  
  unless ( $data ) {
    my $json_error = {
      failue => 'true',
      errstr => 'Error delete user',
    };
    
  return $self->render(json => $json_error, status => HTTP_UNPROCESSABLE_ENTITY );
  }
  
  my $json = {
    success => 'true',
    data => $data,
  };
  
  return $self->render(json => $json, status => HTTP_OK);
}  

sub update_user {
  my $self = shift;
  my $user_id = $self->param('id') || 0;
  my $mail = $self->param('mail');
  my $first_name = $self->param('first_name');
  my $last_name = $self->param('last_name');
  my $address = $self->param('address');
  
  my $rs = $self->db->resultset('User');

  my $data = $rs->find({ user_id => $user_id })->update({ mail => $mail, first_name => $first_name, last_name => $last_name, address => $address });
  
  unless ( $data ) {
    my $json_error = {
      failue => 'true',
      errstr => 'Error update user',
    };
    
  return $self->render(json => $json_error, status => HTTP_UNPROCESSABLE_ENTITY);
  }
  
  my $json = {
    success => 'true',
    data => $data,
  };
  
  return $self->render(json => $json, status => HTTP_OK); 
}  

1;
