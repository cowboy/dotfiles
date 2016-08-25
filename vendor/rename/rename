#!/usr/bin/env perl
use strict;
use warnings;

use Getopt::Long 2.24, qw( :config bundling no_ignore_case no_auto_abbrev );

my ( $N, $EXT, @EXT, @USE, $DECODE, $ENCODE );
sub compile { eval shift } # defined early to control the lexical environment

my $msglevel = 0;
sub ERROR (&) { print STDERR $_[0]->(), "\n" if $msglevel > -1 };
sub INFO  (&) { print STDERR $_[0]->(), "\n" if $msglevel >  0 };
sub DEBUG (&) { print STDERR $_[0]->(), "\n" if $msglevel >  1 };

sub pod2usage { require Pod::Usage;     goto &Pod::Usage::pod2usage }
sub mkpath    { require File::Path;     goto &File::Path::mkpath }
sub dirname   { require File::Basename; goto &File::Basename::dirname }

use constant VERB_FOR => {
	link => {
		inf   => 'link',
		pastp => 'linked',
		exec  => sub { link shift, shift },
	},
	symlink => {
		inf   => 'symlink',
		pastp => 'symlinked',
		exec  => sub { symlink shift, shift },
	},
	rename => {
		inf   => 'rename',
		pastp => 'renamed',
		exec  => sub { rename shift, shift },
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

sub pipe_through {
	my ( $cmd ) = @_;
	IPC::Open2::open2( my $in, my $out, $cmd ) or do {
		warn "couldn't open pipe to $cmd: $!\n";
		return;
	};
	print $out $_;
	close $out;
	$_ = <$in>;
	chomp;
	close $in;
}

my ( $VERB, @EXPR );

my %library = (
	camelcase => 's/([[:alpha:]]+)/\u$1/g',
	urlesc    => 's/%([0-9A-F][0-9A-F])/chr hex $1/ieg',
	nows      => 's/[_[:blank:]]+/_/g',
	rews      => 'y/_/ /',
	noctrl    => 's/[_[:cntrl:]]+/_/g',
	nometa    => 'tr/_!"&()=?`*\':;<>|$/_/s',
	trim      => 's/\A[ _]+//, s/[ _]+\z//'
);

GetOptions(
	'h|help'                    => sub { pod2usage() },
	'man'                       => sub { pod2usage( -verbose => 2 ) },
	'0|null'                    => \my $opt_null,
	'f|force'                   => \my $opt_force,
	'g|glob'                    => \my $opt_glob,
	'i|interactive'             => \my $opt_interactive,
	'k|backwards|reverse-order' => \my $opt_backwards,
	'l|symlink'                 => sub { $VERB ? pod2usage( -verbose => 1 ) : ( $VERB = VERB_FOR->{ 'symlink' } ) },
	'L|hardlink'                => sub { $VERB ? pod2usage( -verbose => 1 ) : ( $VERB = VERB_FOR->{    'link' } ) },
	'M|use=s'                   => \@USE,
	'n|just-print|dry-run'      => \my $opt_dryrun,
	'N|counter-format=s'        => \my $opt_ntmpl,
	'p|mkpath|make-dirs'        => \my $opt_mkpath,
	'stdin!'                    => \my $opt_stdin,
	't|sort-time'               => \my $opt_time_sort,
	'T|transcode=s'             => \my $opt_transcode,
	'v|verbose+'                => \$msglevel,

	'a|append=s'                => sub { push @EXPR, "\$_ .= qq[${\quotemeta $_[1]}]" },
	'A|prepend=s'               => sub { push @EXPR, "substr \$_, 0, 0, qq[${\quotemeta $_[1]}]" },
	'c|lower-case'              => sub { push @EXPR, 's/([[:upper:]]+)/\L$1/g' },
	'C|upper-case'              => sub { push @EXPR, 's/([[:lower:]]+)/\U$1/g' },
	'd|delete=s'                => sub { push @EXPR, "s/${\quotemeta $_[1]}//" },
	'D|delete-all=s'            => sub { push @EXPR, "s/${\quotemeta $_[1]}//g" },
	'e|expr=s'                  => \@EXPR,
	'P|pipe=s'                  => sub { require IPC::Open2; push @EXPR, "pipe_through '\Q$_[1]\E'" },
	's|subst'                   => sub { push @EXPR, argv_to_subst_expr },
	'S|subst-all'               => sub { push @EXPR, argv_to_subst_expr('g') },
	'x|remove-extension'        => sub { push @EXPR, 's/\. [^.]+ \z//x' },
	'X|keep-extension'          => sub { push @EXPR, 's/\.([^.]+)\z//x and do { push @EXT, $1; $EXT = join ".", reverse @EXT }' },
	'z|sanitize'                => sub { push @EXPR, @library{ qw( nows noctrl nometa trim ) } },

	map { my $recipe = $_; $recipe => sub { push @EXPR, $library{ $recipe } } } keys %library,
) or pod2usage();

$opt_stdin = @ARGV ? 0 : 1 unless defined $opt_stdin;

$VERB ||= VERB_FOR->{ 'rename' };

if ( not @EXPR ) {
	pod2usage() if not @ARGV or -e $ARGV[0];
	push @EXPR, shift;
}

pod2usage( -message => 'Error: --stdin and filename arguments are mutually exclusive' )
	if $opt_stdin and @ARGV;

pod2usage( -message => 'Error: --null only permitted when reading filenames from STDIN' )
	if $opt_null and not $opt_stdin;

pod2usage( -message => 'Error: --interactive and --force are mutually exclusive' )
	if $opt_interactive and $opt_force;

my $n = 1;
my $nwidth = 0;
if ( defined $opt_ntmpl ) {
	$opt_ntmpl =~ /\A(?:(\.\.\.0)|(0+))([0-9]+)\z/
		or pod2usage( -message => "Error: unparseable counter format $opt_ntmpl" );
	$nwidth = (
		defined $1 ? -1 :
		defined $2 ? length $opt_ntmpl :
		0
	);
	$n = $3;
}

++$msglevel if $opt_dryrun;

my $code = do {
	if ( $opt_transcode ) {
		require Encode;
		my ( $in_enc, $out_enc ) = split /:/, $opt_transcode, 2;
		$DECODE = Encode::find_encoding( $in_enc );
		die "No such encoding $in_enc\n" if not ref $DECODE;
		$ENCODE = defined $out_enc ? Encode::find_encoding( $out_enc ) : $ENCODE;
		die "No such encoding $out_enc\n" if not ref $ENCODE;
		unshift @EXPR, '$_ = $DECODE->decode($_)';
		push    @EXPR, '$_ = $ENCODE->encode($_)';
	}

	my $i = $#USE;
	for ( reverse @USE ) {
		s/\A([^=]+)=?//;
		my $use = "use $1";
		$use .= ' split /,/, $USE['.$i--.']' if length;
		unshift @EXPR, $use;
	}

	if ( eval 'require feature' and $^V =~ /^v(5\.[1-9][0-9]+)/ ) {
		unshift @EXPR, "use feature ':$1'";
	}

	my $cat = sprintf 'sub { %s }', join '; ', @EXPR;
	DEBUG { "Using expression: $cat" };

	my $evaled = compile $cat;
	die $@ if $@;
	die "Evaluation to subref failed. Check expression using -nv\n"
		unless 'CODE' eq ref $evaled;

	$evaled;
};

if ( $opt_stdin ) {
	local $/ = $/;
	INFO { "Reading filenames from STDIN" };
	@ARGV = do {
		if ( $opt_null ) {
			INFO { "Splitting on NUL bytes" };
			$/ = chr 0;
		}
		<STDIN>;
	};
	chomp @ARGV;
}

@ARGV = map glob, @ARGV if $opt_glob;

if ( $opt_time_sort ) {
	my @mtime = map { (stat)[9] } @ARGV;
	@ARGV = @ARGV[ sort { $mtime[$a] <=> $mtime[$b] } 0 .. $#ARGV ];
}

@ARGV = reverse @ARGV if $opt_backwards;

$nwidth = length $n+@ARGV if $nwidth < 0;

for ( @ARGV ) {
	my $old = $_;

	$N = sprintf '%0*d', $nwidth, $n++;
	$code->();
	$_ = join '.', $_, reverse splice @EXT if @EXT;

	if ( $old eq $_ ) {
		DEBUG { "'$old' unchanged" };
		next;
	}

	if ( !$opt_force and -e ) {
		ERROR { "'$old' not $VERB->{pastp}: '$_' already exists" };
		next;
	}

	if ( $opt_dryrun ) {
		INFO { "'$old' would be $VERB->{pastp} to '$_'" };
		next;
	}

	if ( $opt_interactive ) {
		print "\u$VERB->{inf} '$old' to '$_'? [n] ";
		if ( <STDIN> !~ /^y(?:es)?$/i ) {
			DEBUG { "Skipping '$old'." };
			next;
		}
	}

	my ( $success, @made_dirs );

	++$success if $VERB->{ 'exec' }->( $old, $_ );

	if ( !$success and $opt_mkpath ) {
		@made_dirs = mkpath( [ dirname( $_ ) ], $msglevel > 1, 0755 );
		++$success if $VERB->{ 'exec' }->( $old, $_ );
	}

	if ( !$success ) {
		ERROR { "Can't $VERB->{inf} '$old' to '$_': $!" };
		rmdir $_ for reverse @made_dirs;
		next;
	}

	INFO { "'$old' $VERB->{pastp} to '$_'" };
}

__END__

=head1 NAME

rename - renames multiple files

=head1 VERSION

version 1.600

=head1 SYNOPSIS

F<rename>
B<[switches|transforms]>
B<[files]>

Switches:

=over 1

=item B<-0>/B<--null> (when reading from STDIN)

=item B<-f>/B<--force>E<nbsp>orE<nbsp>B<-i>/B<--interactive> (proceed or prompt when overwriting)

=item B<-g>/B<--glob> (expand C<*> etc. in filenames, useful in WindowsE<trade> F<CMD.EXE>)

=item B<-k>/B<--backwards>/B<--reverse-order>

=item B<-l>/B<--symlink>E<nbsp>orE<nbsp>B<-L>/B<--hardlink>

=item B<-M>/B<--use=I<Module>>

=item B<-n>/B<--just-print>/B<--dry-run>

=item B<-N>/B<--counter-format>

=item B<-p>/B<--mkpath>/B<--make-dirs>

=item B<--stdin>/B<--no-stdin>

=item B<-t>/B<--sort-time>

=item B<-T>/B<--transcode=I<encoding>>

=item B<-v>/B<--verbose>

=back

Transforms, applied sequentially:

=over 1

=item B<-a>/B<--append=I<str>>

=item B<-A>/B<--prepend=I<str>>

=item B<-c>/B<--lower-case>

=item B<-C>/B<--upper-case>

=item B<-d>/B<--delete=I<str>>

=item B<-D>/B<--delete-all=I<str>>

=item B<-e>/B<--expr=I<code>>

=item B<-P>/B<--pipe=I<cmd>>

=item B<-s>/B<--subst I<from> I<to>>

=item B<-S>/B<--subst-all I<from> I<to>>

=item B<-x>/B<--remove-extension>

=item B<-X>/B<--keep-extension>

=item B<-z>/B<--sanitize>

=item B<--camelcase>E<nbsp>B<--urlesc>E<nbsp>B<--nows>E<nbsp>B<--rews>E<nbsp>B<--noctrl>E<nbsp>B<--nometa>E<nbsp>B<--trim> (see manual)

=back

=head1 DESCRIPTION

This program renames files according to modification rules specified on the command line. If no filenames are given on the command line, a list of filenames will be expected on standard input.

The documentation contains a L</TUTORIAL>.

=head1 OPTIONS

=head2 Switches

=over 4

=item B<-h>, B<--help>

See a synopsis.

=item B<--man>

Browse the manpage.

=item B<-0>, B<--null>

When reading file names from C<STDIN>, split on NUL bytes instead of newlines. This is useful in combination with GNU find's C<-print0> option, GNU grep's C<-Z> option, and GNU sort's C<-z> option, to name just a few. B<Only valid if no filenames have been given on the commandline.>

=item B<-f>, B<--force>

Rename even when a file with the destination name already exists.

=item B<-g>, B<--glob>

Glob filename arguments. This is useful if you're using a braindead shell such as F<cmd.exe> which won't expand wildcards on behalf of the user.

=item B<-i>, B<--interactive>

Ask the user to confirm every action before it is taken.

=item B<-k>, B<--backwards>, B<--reverse-order>

Process the list of files in reverse order, last file first. This prevents conflicts when renaming files to names which are currently taken but would be freed later during the process of renaming.

=item B<-l>, B<--symlink>

Create symlinks from the new names to the existing ones, instead of renaming the files. B<Cannot be used in conjunction with C<-L>.>

=item B<-L>, B<--hardlink>

Create hard links from the new names to the existing ones, instead of renaming the files. B<Cannot be used in conjunction with C<-l>.>

=item B<-M>, B<--use>

Like perl's own C<-M> switch. Loads the named modules at the beginning of the rename, and can pass import options separated by commata after an equals sign, i.e. C<Module=foo,bar> will pass the C<foo> and C<bar> import options to C<Module>.

You may load multiple modules by using this option multiple times.

=item B<-n>, B<--dry-run>, B<--just-print>

Show how the files would be renamed, but don't actually do anything.

=item B<-N>/B<--counter-format>

Format and set the C<$N> counter variable according to the given template.

E.g. C<-N 001> will make C<$N> start at 1 and be zero-padded to 3 digits, whereas C<-N 0099> will start the counter at 99 and zero-pad it to 4 digits. And so forth. Only digits are allowed in this simple form.

As a special form, you can prefix the template with C<...0> to indicate that C<rename> should determine the width automatically based upon the number of files. E.g. if you pass C<-N ...01> along with 300 files, C<$N> will range from C<001> to C<300>.

=item B<-p>, B<--mkpath>, B<--make-dirs>

Create any non-existent directories in the target path. This is very handy if you want to scatter a pile of files into subdirectories based on some part of their name (eg. the first two letters or the extension): you don't need to make all necessary directories beforehand, just tell C<rename> to create them as necessary.

=item B<--stdin>, B<--no-stdin>

Always E<ndash> or never E<ndash> read the list of filenames from STDIN; do not guess based on the presence or absence of filename arguments. B<Filename arguments must not be present when using C<--stdin>.>

=item B<-T>, B<--transcode>

Decode each filename before processing and encode it after processing, according to the given encoding supplied.

To encode output in a different encoding than input was decoded, supply two encoding names, separated by a colon, e.g. C<-T latin1:utf-8>.

Only the last C<-T> parameter on the command line is effective.

=item B<-v>, B<--verbose>

Print additional information about the operations (not) executed.

=back

=head2 Transforms

Transforms are applied to filenames sequentially. You can use them multiple times; their effects will accrue.

=over 4

=item B<-a>, B<--append>

Append the string argument you supply to every filename.

=item B<-A>, B<--prepend>

Prepend the string argument you supply to every filename.

=item B<-c>, B<--lower-case>

Convert file names to all lower case.

=item B<-C>, B<--upper-case>

Convert file names to all upper case.

=item B<-e>, B<--expr>

The C<code> argument to this option should be a Perl expression that assumes the filename in the C<$_> variable and modifies it for the filenames to be renamed. When no other C<-c>, C<-C>, C<-e>, C<-s>, or C<-z> options are given, you can omit the C<-e> from infront of the code.

=item B<-P>, B<--pipe>

Pass the filename to an external command on its standard input and read back the transformed filename on its standard output.

=item B<-s>, B<--subst>

Perform a simple textual substitution of C<from> to C<to>. The C<from> and C<to> parameters must immediately follow the argument.

=item B<-S>, B<--subst-all>

Same as C<-s>, but replaces I<every> instance of the C<from> text by the C<to> text.

=item B<-x>, B<--remove-extension>

Remove the last extension from a filename, if there is any.

=item B<-X>, B<--keep-extension>

Save and remove the last extension from a filename, if there is any. The saved extension will be appended back to the filename at the end of the rest of the operations.

Repeating this option will save multiple levels of extension in the right order.

=item B<-z>, B<--sanitize>

A shortcut for passing C<--nows --noctrl --nometa --trim>.

=item B<--camelcase>

Capitalise every separate word within the filename.

=item B<--urlesc>

Decode URL-escaped filenames, such as wget(1) used to produce.

=item B<--nows>

Replace all sequences of whitespace in the filename with single underscore characters.

=item B<--rews>

Reverse C<--nows>: replace each underscore in the filename with a space.

=item B<--noctrl>

Replace all sequences of control characters in the filename with single underscore characters.

=item B<--nometa>

Replace every shell meta-character with an underscore.

=item B<--trim>

Remove any sequence of spaces and underscores at the left and right ends of the filename.

=back

=head1 VARIABLES

These predefined variables are available for use within any C<-e> expressions you pass.

=over 4

=item B<$N>

A counter that increments for each file in the list. By default, counts up from 1.

The C<-N> switch takes a template that specifies the padding and starting value of C<$N>; see L</Switches>.

=item B<$EXT>

A string containing the accumulated extensions saved by C<-X> switches, without a leading dot. See L</Switches>.

=item B<@EXT>

An array containing the accumulated extensions saved by C<-X> switches, from right to left, without any dots.

The right-most extension is always C<$EXT[0]>, the left-most (if any) is C<$EXT[-1]>.

=back

=head1 TUTORIAL

F<rename> takes a list of filenames, runs a list of modification rules against each filename, checks if the result is different from the original filename, and if so, renames the file. The most I<flexible> way to use it is to pass a line of Perl code as the rule; the most I<convenient> way is to employ the many switches available to supply rules for common tasks such as stripping extensions.

For example, to strip the extension from all C<.bak> files, you might use either of these command lines:

 rename -x *.bak
 rename 's/\.bak\z//' *

These do not achive their results in exactly the same way: the former only takes the files that match C<*.bak> in the first place, then strips their last extension; the latter takes all files and strips a C<.bak> from the end of those filenames that have it. As another alternative, if you are confident that none of the filenames has C<.bak> anywhere else than at the end, you might instead choose to write the latter approach using the C<-s> switch:

 rename -s .bak '' *

Of course you can do multiple changes in one go:

 rename -s .tgz .tar.gz -s .tbz2 .tar.bz2 *.t?z*

But note that transforms are order sensitive. The following will not do what you probably meant:

 rename -s foo bar -s bar baz *

Because rules are cumulative, this would first substitute F<foo> with F<bar>; in the resulting filenames, it would then substitute F<bar> with F<baz>. So in most cases, it would end up substituting F<foo> with F<baz> E<ndash> probably not your intention. So you need to consider the order of rules.

If you are unsure that your modification rules will do the right thing, try doing a verbose dry run to check what its results would be. A dry run is requested by passing C<-n>:

 rename -n -s bar baz -s foo bar *

You can combine the various transforms to suit your needs. E.g. files from MicrosoftE<trade> WindowsE<trade> systems often have blanks and (sometimes nothing but) capital letters in their names. Let's say you have a heap of such files to clean up, I<and> you also want to move them to subdirectories based on extension. The following command will do this for you:

 rename -p -c -z -X -e '$_ = "$EXT/$_" if @EXT' *

Here, C<-p> tells F<rename> to create directories if necessary; C<-c> tells it to lower-case the filename; C<-X> remembers the file extension in the C<$EXT> and C<@EXT> variables; and finally, the C<-e> expression uses those to prepend the extension to the filename as a directory, I<if> there is one.

That brings us to the secret weapon in F<rename>'s arsenal: the C<-X> switch. This is a transform that clips the extension off the filename and stows it away at that point during the application of the rules. After all rules are finished, the remembered extension is appended back onto the filename. (You can use multiple C<-X> switches, and they will accumulate multiple extensions as you would expect.) This allows you to do use simple way for doing many things that would get much trickier if you had to make sure to not affect the extension. E.g.:

 rename -X -c --rews --camelcase --nows *

This will uppercase the first letter of every word in every filename while leaving its extension exactly as before. Or, consider this:

 rename -N ...01 -X -e '$_ = "File-$N"' *

This will throw away all the existing filenames and simply number the files from 1 through however many files there are E<ndash> except that it will preserve their extensions.

Incidentally, note the C<-N> switch and the C<$N> variable used in the Perl expression. See L</Switches> and L</VARIABLES> for documentation.

=head1 COOKBOOK

Using the C<-M> switch, you can quickly put F<rename> to use for just about everything the CPAN offers:

=head3 Coarsely latinize a directory full of files with non-Latin characters

 rename -T utf8 -MText::Unidecode '$_ = unidecode $_' *

See L<Text::Unidecode>.

=head3 Sort a directory of pictures into monthwise subdirectories

 rename -p -MImage::EXIF '$_ = "$1-$2/$_" if Image::EXIF->new->file_name($_)
   ->get_image_info->{"Image Created"} =~ /(\d\d\d\d):(\d\d)/' *.jpeg

See L<Image::EXIF>.

=head1 SEE ALSO

mv(1), perl(1), find(1), grep(1), sort(1)

=head1 BUGS

None currently known.

=head1 AUTHORS

Aristotle Pagaltzis

Idea, inspiration and original code from Larry Wall and Robin Barker.

=head1 COPYRIGHT

This script is free software; you can redistribute it and/or modify it under the same terms as Perl itself.
