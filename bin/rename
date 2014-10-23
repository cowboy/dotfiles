#!/usr/bin/perl
use strict;
use warnings;

=head1 NAME

rename - renames multiple files

=head1 SYNOPSIS

F<rename>
S<B<-h>>

F<rename>
S<B<--man>>

F<rename>
S<B<[ -0 ]>>
S<B<[ -c ]>>
S<B<[ -C ]>>
S<B<[ -e code ]>>
S<B<[ -f ]>>
S<B<[ -i ]>>
S<B<[ -l | -L ]>>
S<B<[ -n ]>>
S<B<[ -s from to ]>>
S<B<[ -v ]>>
S<B<[ files ]>>

=head1 DESCRIPTION

C<rename> renames the filenames supplied according to the rules specified. If a given filename is not modified, it will not be renamed. If no filenames are given on the command line, filenames will be read via standard input.

For example, to rename all files matching C<*.bak> to strip the extension, you might say

 rename 's/\.bak$//' *.bak

If are confident that none of the filenames has C<.bak> anywhere else than at the end, you can also use the much easier typed

 rename -s .bak '' *.bak

You can always do multiple changes in one ago:

 rename -s .tgz .tar.gz -s .tbz2 .tar.bz2 *.tar.*

Note however that expressive options are order sensitive. The following would probably surprise you:

 rename -s foo bar -s bar baz *

Since operations are cumulative, this would end up substituting (some of) the F<foo> matches in filenames with F<baz>! So pay attention to order. You may want to request a verbose dry run with C<-nv> for the first stab at a complex rename operation.

 rename -nv -s bar baz -s foo bar *

You can combine the various expressive options to suit your needs. F.ex files from Microsoft(tm) Windows systems often have blanks and (sometimes nothing but) capital letters in their names. Let's say you have a bunch of such files to clean up, and you also want to move them to subdirectories based on extension. The following command should help, provided all directories already exist:

 rename -cz -e '$_ = "$1/$_" if /(\..*)\z/' *

Again you need to pay attention to order sensitivity for expressive options. If you placed the C<-c> after the C<-e> in the above example, files with F<.zip> and F<.ZIP> extensions would be (attempted to be) moved to different directories because the directory name prefix would be added before the filenames were normalized. Once again, use verbose dry run requested using C<-nv> to get an idea of what exactly a complex rename operation is going to do.

=head1 ARGUMENTS

=over 4

=item B<-h>, B<--help>

See a synopsis.

=item B<--man>

Browse the manpage.

=back

=head1 OPTIONS

=over 4

=item B<-0>, B<--null>

When reading file names from C<STDIN>, split on NUL bytes instead of newlines. This is useful in combination with GNU find's C<-print0> option, GNU grep's C<-Z> option, and GNU sort's C<-z> option, to name just a few. B<Only valid if no filenames have been given on the commandline.>

=item B<-c>, B<--lower-case>

Converts file names to all lower case.

=item B<-C>, B<--upper-case>

Converts file names to all upper case.

=item B<-e>, B<--expr>

The C<code> argument to this option should be a Perl expression that assumes the filename in the C<$_> variable and modifies it for the filenames to be renamed. When no other C<-c>, C<-C>, C<-e>, C<-s>, or C<-z> options are given, you can omit the C<-e> from infront of the code.

=item B<-g>, B<--glob>

Glob filename arguments. This is useful if you're using a braindead shell such as F<cmd.exe> which won't expand wildcards on behalf of the user.

=item B<-f>, B<--force>

Rename even when a file with the destination name already exists.

=item B<-i>, B<--interactive>

Ask the user to confirm every action before it is taken.

=item B<-k>, B<--backwards>, B<--reverse-order>

Process the list of files in reverse order, last file first. This prevents conflicts when renaming files to names which are currently taken but would be freed later during the process of renaming.

=item B<-l>, B<--symlink>

Create symlinks from the new names to the existing ones, instead of renaming the files. B<Cannot be used in conjunction with C<-L>.>

=item B<-L>, B<--hardlink>

Create hard links from the new names to the existing ones, instead of renaming the files. B<Cannot be used in conjunction with C<-l>.>

=item B<-n>, B<--dry-run>, B<--just-print>

Show how the files would be renamed, but don't actually do anything.

=item B<-s>, B<--subst>, B<--simple>

Perform a simple textual substitution of C<from> to C<to>. The C<from> and C<to> parameters must immediately follow the argument.

Quoting issues aside, this is equivalent to supplying a C<-e 's/\Qfrom/to/'>.

=item B<-v>, B<--verbose>

Print additional information about the operations (not) executed.

=item B<-z>, B<--sanitize>

Replaces consecutive blanks, shell meta characters, and control characters in filenames with underscores.

=back

=head1 SEE ALSO

mv(1), perl(1), find(1), grep(1), sort(1)

=head1 BUGS

None currently known.

=head1 AUTHORS

Aristotle Pagaltzis

Idea, inspiration and original code from Larry Wall and Robin Barker.

=head1 COPYRIGHT

This script is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut

use Pod::Usage;
use Getopt::Long 2.24, qw(:config bundling no_ignore_case no_auto_abbrev);

use constant ERROR    => do { bless \(my $l = 0), 'LOGLEVEL' };
use constant INFO     => do { bless \(my $l = 1), 'LOGLEVEL' };
use constant DEBUG    => do { bless \(my $l = 2), 'LOGLEVEL' };
use constant VERB_FOR => {
	link => {
		inf   => 'link',
		pastp => 'linked',
		exec  => sub { link shift, shift or die },
	},
	symlink => {
		inf   => 'symlink',
		pastp => 'symlinked',
		exec  => sub { symlink shift, shift or die },
	},
	rename => {
		inf   => 'rename',
		pastp => 'renamed',
		exec  => sub { rename shift, shift or die },
	},
};

sub argv_to_subst_expr {
	my $modifier = shift || '';
	pod2usage( -verbose => 1 ) if @ARGV < 2;
	my ($from, $to) = map quotemeta, splice @ARGV, 0, 2;
	# the ugly \${\""} construct is necessary because unknown backslash escapes are
	# not treated the same in pattern- vs doublequote-quoting context; only the
	# latter lets us do the right thing with problematic input like
	# ']{ool(haracter$' or maybe '>><//((/>'
	sprintf 's/\Q${\"%s"}/%s/%s', $from, $to, $modifier;
}

my @EXPR;

GetOptions(
	'h|help'                    => sub { pod2usage( -verbose => 1 ) },
	'man'                       => sub { pod2usage( -verbose => 2 ) },
	'0|null'                    => \my $opt_null,
	'c|lower-case'              => sub { push @EXPR, 's/([[:upper:]]+)/\L$1/g' },
	'C|upper-case'              => sub { push @EXPR, 's/([[:lower:]]+)/\U$1/g' },
	'e|expr=s'                  => \@EXPR,
	'f|force'                   => \my $opt_force,
	'g|glob'                    => \my $opt_glob,
	'i|interactive'             => \my $opt_interactive,
	'k|backwards|reverse-order' => \my $opt_backwards,
	'l|symlink'                 => \my $opt_symlink,
	'L|hardlink'                => \my $opt_hardlink,
	'n|just-print|dry-run'      => \my $opt_dryrun,
	'p|mkpath|make-dirs'        => \my $opt_mkpath,
	'v|verbose+'                => \(my $opt_verbose = 0),
	'z|sanitize'                => sub { push @EXPR, 's/[!"\$&()=?`*\';<>|_[:cntrl:][:blank:]]+/_/g' },
	's|subst|simple'            => sub { push @EXPR, argv_to_subst_expr },
	'S|subst-global'            => sub { push @EXPR, argv_to_subst_expr('g') },
) or pod2usage( -verbose => 1 );

die "TODO" if $opt_mkpath;

if(not @EXPR) {
	pod2usage( -verbose => 1 ) if not @ARGV or -e $ARGV[0];
	push @EXPR, shift;
}

pod2usage( -verbose => 1 )
	if ($opt_hardlink and $opt_symlink)
	or ($opt_null and @ARGV);

++$opt_verbose if $opt_dryrun;

BEGIN {
	*CORE::GLOBAL::warn = sub {
		if(ref $_[0] eq 'LOGLEVEL') {
			my $msglevel = ${(shift)};
			print "@_\n" if $opt_verbose >= $msglevel;
			return;
		}
		warn @_;
	};
}

my $code = do {
	my $cat = "sub { ".join('; ', @EXPR)." }";
	warn DEBUG, "Using expression: $cat";

	my $evaled = eval $cat;
	die $@ if $@;
	die "Evaluation to subref failed. Check expression using -vn\n"
		unless 'CODE' eq ref $evaled;

	$evaled;
};

my $verb = VERB_FOR->{
	$opt_hardlink ? 'link' :
	$opt_symlink  ? 'symlink' :
	do { 'rename' }
};

if (!@ARGV) {
	warn INFO, "Reading filenames from STDIN";
	@ARGV = do {
		if($opt_null) {
			warn INFO, "Splitting on NUL bytes";
			local $/ = "\0";
		}
		<STDIN>;
	};
	chomp @ARGV;
}

@ARGV = map glob, @ARGV if $opt_glob;

@ARGV = reverse @ARGV if $opt_backwards;

for (@ARGV) {
    my $old = $_;

	$code->();

	if($old eq $_) {
		warn DEBUG, "'$old' unchanged";
		next;
	}

	if(!$opt_force and -e) {
		warn ERROR, "'$old' not $verb->{pastp}: '$_' already exists";
		next;
	}

	if($opt_dryrun) {
		warn INFO, "'$old' would be $verb->{pastp} to '$_'";
		next;
	}

	if($opt_interactive) {
		print "\u$verb->{inf} '$old' to '$_'? [n] ";
		if(<STDIN> !~ /^y(?:es)?$/i) {
			warn DEBUG, "Skipping '$old'.";
			next;
		}
	}

	eval { $verb->{exec}($old, $_) };

	if($@) {
		warn ERROR, "Can't $verb->{inf} '$old' to '$_': $!";
		next;
	}

	warn INFO, "'$old' $verb->{pastp} to '$_'";
}
