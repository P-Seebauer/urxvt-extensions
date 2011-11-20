#This Code is Licenced under the Perl Artistic License
#you might have been able to get this License if you got this Code

use 5.01;
use Desktop::Notify;

my ($watch, $prefix, $notify_daemon) =
   ("",    'activityWatcher-');

sub on_start{
  my ($t) = @_;
  $t->parse_keysym("M-C-a", "perl:$prefix"."activity");
  $t->parse_keysym("M-C-i", "perl:$prefix"."inactivity");
  $notify_daemon = Desktop::Notify->new();

  ()
}


sub on_user_command {
  my($term, $string) = @_;
  if($string =~ /$prefix(.*)$/){
    $watch = $watch eq $1 ? '' : $1;
    indicate_status($term);
    if($watch eq 'inactivity'){
      $term->{inactivity_timer} = urxvt::timer
      -> new
      -> after(2)
      -> cb(sub{
          my_notify('inactive');
          $watch = "";
        });
    }
  }

  ()
}


sub on_add_lines {
  if($watch eq 'activity'){
      my_notify('active');
      $watch = "";
  }
  elsif($watch eq 'inactivity'){
    $term->{inactivity_timer}->after(2);
  }

  ()
}

sub indicate_status {
  my ($term) = @_;
  $term->overlay_simple(-1,0,$watch) if $watch;
}

sub my_notify {
  my($what) = @_;
  warn "my notify called whith: @_)";
  $notify_daemon->create(summary => "Shell was $what",
			timeout => 5000,
			body => <<BODY )
You requested to be notified, when the shell goes $what.
BODY
  ->show();
}
