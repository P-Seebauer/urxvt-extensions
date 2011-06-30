#!/usr/bin/env perl

use warnings;
use strict;
use 5.01;
use Desktop::Notify;

my ($watch, $prefix) = ("", 'activityWatcher-');

sub on_init{
  my ($t) = @_;
  $t->parse_keysym("M-C-a", "perl:$prefix"."activity");
  $t->parse_keysym("M-C-i", "perl:$prefix"."inactivity");
}

sub on_user_command {
  my($term, $string) = @_;
  if($string =~ /$prefix(.*)$/){
    $watch = $watch eq $1 ? '' : $1;
    indicate_local($term);
  }
}


sub indicate_local {
  my ($term) = @_;
  $term->overlay_simple(-1,0,$watch) if $watch;
}

my $timer;
