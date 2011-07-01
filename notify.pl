#This Code is Licenced under the Perl Artistic License
#you might have been able to get this License if you got this Code

use 5.01;
use Desktop::Notify;

my ($watch, $prefix, $notify_daemon) =
   ("",    'activityWatcher-');

sub on_init{
  my ($t) = @_;
  $t->parse_keysym("M-C-a", "perl:$prefix"."activity");
  $t->parse_keysym("M-C-i", "perl:$prefix"."inactivity");
  $notify_daemon = Desktop::Notify->new();
}

my $timer;
sub on_user_command {
  my($term, $string) = @_;
  if($string =~ /$prefix(.*)$/){
    $watch = $watch eq $1 ? '' : $1;
    indicate_status($term);
    if($watch eq 'inactivity'){
      (my $iw = new urxvt::iw)
	->cb(sub{my ($i) = @_;
		 my_notify('inactive');
		 $i->stop;
	     })
	->start;
    }
  }
}

sub on_line_update{
  return unless $watch;
  if($watch eq 'activity'){
      my_notify('active');
      $watch = "";
    }
}

sub indicate_status {
  my ($term) = @_;
  $term->overlay_simple(-1,0,$watch) if $watch;
  warn "foo";
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
