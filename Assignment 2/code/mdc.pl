#!/usr/bin/perl

use strict;
use warnings;
use integer;

sub lexemize($);
sub tokenize(@);
sub interpret(@);
sub doall($);

# main
# parse command line args and act correspondingly
if (@ARGV) {
	# process all args
	while (@ARGV) {
		my $arg = shift @ARGV;
		if ($arg =~ /-e$/) { doall shift @ARGV }
		else {
			my $file = (($arg =~ /-f$/) ? shift @ARGV : $arg);
			open (FILE, "<$file") or die "cannot open file '$file' for reading\n";
			doall <FILE>
		 }
	}
} else {
	# no args, read stdin
	doall <> ;
}

# lexemize: input string -> list of lexemes
sub lexemize ($) {
	my ($input) = @_;
	$input =~ s/^\s+|\s+$//g;
	return split /\s+/, $input;
}

# tokenize: list of lexemes -> list of tokens
sub tokenize (@) {
	my @lexemes = @_;
	return map {
		my $lexeme = $_;
		$lexeme =~ /^[pfrd]$/ ? ['cmd', $lexeme] :
		$lexeme =~ /^[+-\/*]$/ ? ['op', $lexeme] :
		$lexeme =~ /^\d+$/ ? ['int', $lexeme] :
		() } @lexemes;
}

# interpret: for each token, execute an action conditionally on its type and value
sub interpret (@) {
	my @tokens = @_;
	my @stack = ();
	foreach my $token (@tokens) {
		my ($type, $value) = @$token;
		if ($type eq 'int') { unshift @stack, $value }
		elsif ($type eq 'op') { unshift @stack, eval join $value, reverse splice @stack, 0, 2 }
		elsif ($type eq 'cmd') {		
			if ($value eq 'p') { print "$stack[0]\n" }
			elsif ($value eq 'f') { print "$_\n" foreach (@stack) }
			elsif ($value eq 'r') { splice @stack, 0, 2, @stack[1,0] }
			elsif ($value eq 'd') { unshift @stack, $stack[0] }
		}
	}
}

# convenience wrapper
sub doall ($) {
	interpret tokenize lexemize shift;
}
