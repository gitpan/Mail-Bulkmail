# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..1\n"; }
END {print "not ok 1\n" unless $loaded;}
use lib ("../", "../../");
use Mail::Bulkmail 2.04;
$loaded = 1;
print "module loaded, continuing...\n\n";

print "What is your email address? ";
chomp(my $email = <STDIN>);
print "\nWhat is your name? ";
chomp (my $name = <STDIN>);
print "\nWhat is the address of your smtp server? ";
chomp (my $smtp = <STDIN>);

eval {
 $bulk = Mail::Bulkmail->new(
 	"LIST"	=> ['invalid_address::Invalid Address', $email . "::" . $name],
 	"GOOD" => \&good,
 	"BAD" => \&bad,
	From	=> $email,
	Subject	=> "Mail::Bulkmail $Mail::Bulkmail::VERSION test",
	merge => {"BULK_MAILMERGE" => "BULK_EMAIL::NAME"},
	Message	=> "Hi there, NAME.  Mail::Bulkmail seems to work fine!",
	Smtp => $smtp,
	"X-test" => "Bulkmail test!"
 ) or die Mail::Bulkmail->error();
 $bulk->bulkmail;


};

sub good {
	print "Mail successfully sent to (@_)\n";
	print "\n\nCheck your email account (@_) in a few minutes.  You should have a\n";
	print "message waiting for you.  If you don't, then something went wrong...\n";
};

sub bad {
	print "Mail did not send to (@_)\n";
	print "    (this is good...'invalid_address' is an internal test case)\n"
		if join("", @_) =~ /invalid_address/;
};

print "\n\n=======\nBE SURE TO SET YOUR DEFAULTS IN THE MODULE!!!\n=======\n\n";

print "...error: $@" if $@;

