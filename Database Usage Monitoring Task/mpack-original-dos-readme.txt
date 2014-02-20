                    mpack/munpack version 1.5 for dos

Mpack and munpack are utilities for encoding and decoding
(respectively) binary files in MIME (Multipurpose Internet Mail
Extensions) format mail messages.  For compatibility with older forms
of transferring binary files, the munpack program can also decode
messages in split-uuencoded format.  The Macintosh version can also
decode messages in split-BinHex format.

Versions are included for unix, pc, os2, mac, amiga and archimedes
systems.  The canonical FTP site for this software is
ftp.andrew.cmu.edu:pub/mpack/

This MIME implementation is intended to be as simple and portable as
possible.  For a slightly more sophisticated MIME implementation, see
the program MetaMail, available via anonymous FTP to
thumper.bellcore.com, in directory pub/nsb


Decoding MIME messages:

To decode a MIME message, first save it to a text file.  If possible,
save it with all headers included.  Munpack can decode some MIME files
when the headers are missing or incomplete, other files it cannot
decode without having the information in the headers.  In general,
messages which have a statement at the beginning that they are in MIME
format can be decoded without the headers.  Messages which have been
split into multiple parts generally require all headers in order to be
reassembled and decoded.

Some LAN-based mail systems and some mail providers (including America
Online, as of the writing of this document) place the mail headers at
the bottom of the message, instead of at the top of the message.  If
you are having problems decoding a MIME message on such a system, you
need to convert the mail back into the standard format by removing the
system's nonstandard headers and moving the standard Internet headers
to the top of the message (separated from the message body with a
blank line).

There must be exactly one message per file.  Munpack cannot deal with
multiple messages in a single file, to decode things correctly it must
know when one message ends and the next one begins.

To decode a message, run the command:

	munpack file

where "file" is the name of the file containing the message.  More than
one filename may be specified, munpack will try to decode the message in
each file.  For more information on ways to run munpack, see the section
"Using munpack" below.


Reporting bugs:

Bugs and comments should be reported to mpack-bugs@andrew.cmu.edu.
When reporting bugs or other problems, please include the following
information:

  * The version number of Mpack
  * The platform (Unix, PC, OS/2, Mac, Amiga, Archimedes)
  * The EXACT output of any unsuccessful attempts.
  * If having a problem decoding, the first couple of lines
    of the input file.


Compilation:

Using mpack:

Mpack is used to encode a file into one or more MIME format messages.
The program is invoked with:

	mpack [options] -o outputfile file

Where "[options]" is one or more optional switches described below.
"-o outputfile" is also described below. "file" is the name of the
file to encode.
The possible options are:

     -s subject
          Set the Subject header field to Subject.   By default,
          mpack will prompt for the contents of the subject
          header.

     -d descriptionfile
          Include the contents of the file descriptionfile in an
          introductory section at the beginning of the first
          generated message.

     -m maxsize
          Split the message (if necessary) into partial messages,
          each not exceeding maxsize characters.  The default
          limit is the value of the SPLITSIZE environment 
	  variable, or no limit if the environment variable
          does not exist.  Specifying a maxsize of 0 means there
          is no limit to the size of the generated message.

     -c content-type
          Label the included file as being of MIME type
          content-type, which must be a subtype of application,
          audio, image, or video.  If this switch is not given,
          mpack examines the file to determine its type.

     -o outputfile
          Write the generated message to the file outputfile.  If
          the message has to be split, the partial messages will
          instead be written to the files outputfile.01,
          outputfile.02, etc.

The environment variables which control mpack's behavior are:

     SPLITSIZE
          Default value of the -m switch.  Default "0".


Using munpack:

Munpack is used to decode one or more messages in MIME or
split-uuencoded format and extract the embedded files.  The program is
invoked with:

	munpack [options] filename...

which reads the messages in the files "filename...".  Munpack may also
be invoked with just:

	munpack [options]

which reads a message from the standard input.

If the message suggests a file name to use for the imbedded part, that
name is cleaned of potential problem characters and used for the
output file.  If the suggested filename includes subdirectories, they
will be created as necessary.  If the message does not suggest a file
name, the names "part1", "part2", etc are used in sequence.

If the imbedded part was preceded with textual information, that
information is also written to a file. The file is named the same as
the imbedded part, with any filename extension replaced with
".desc"

The possible options are:

     -f
          Forces the overwriting of existing files.  If a message
          suggests a file name of an existing file, the file will be

     -t
	  Also unpack the text parts of multipart messages to files.
	  By default, text parts that do not have a filename parameter
	  do not get unpacked.

     -q
          Be quiet--suppress messages about saving partial messages.

     -C directory
          Change the current directory to "directory" before reading
          any files.  This is useful when invoking munpack
          from a mail or news reader.

The environment variables which control munpack's behavior are:


Acknowledgements:

Written by John G. Myers, jgm+@cmu.edu

The mac version was written by Christopher J. Newman, chrisn+@cmu.edu

The amiga port was done by Mike W. Meyer, mwm@contessa.phone.net and
Peter Simons, simons@peti.GUN.de

The os2 port was done by Jochen Friedrich, jochen@audio.pfalz.de

The archimedes port was done by Olly Betts, olly@mantis.co.uk

Send all bug reports to mpack-bugs@andrew.cmu.edu 

Thanks to Nathaniel Borenstein for testing early versions of mpack and
for making many helpful suggestions.


PGP signature:

Starting with version 1.5, all official mpack distributions are PGP
signed by "John Gardiner Myers <jgm+@cmu.edu>".  The PGP signatures
are detached from the distributions themselves, in files with the
".asc" filename extension.  If the location where you obtained mpack
does not include the PGP signature, or if the signature is not valid
for the distribution, please complain to the maintainer of the
relevant distribution site.

A valid PGP signature indicates that the distribution is the one that
I put together; it specifically does not indicate any warranty of any
kind on the software.  The Unix and DOS versions were done by myself,
the DOS binaries were checked for viruses using an up-to-date virus
checker.  The Macintosh version was done by a colleague I have reason
to trust.  All other versions were done and compiled by people I have
had no personal contact with.

My PGP public key follows:

-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: 2.6.1

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
Wi3bjI/bpV0eE+g=
=pCCQ
-----END PGP PUBLIC KEY BLOCK-----

Legalese:

(C) Copyright 1993,1994 by Carnegie Mellon University
All Rights Reserved.

Permission to use, copy, modify, distribute, and sell this software
and its documentation for any purpose is hereby granted without fee,
provided that the above copyright notice appear in all copies and that
both that copyright notice and this permission notice appear in
supporting documentation, and that the name of Carnegie Mellon
University not be used in advertising or publicity pertaining to
distribution of the software without specific, written prior
permission.  Carnegie Mellon University makes no representations about
the suitability of this software for any purpose.  It is provided "as
is" without express or implied warranty.

CARNEGIE MELLON UNIVERSITY DISCLAIMS ALL WARRANTIES WITH REGARD TO
THIS SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS, IN NO EVENT SHALL CARNEGIE MELLON UNIVERSITY BE LIABLE
FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING
OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
SOFTWARE.

Portions of this software are derived from code written by Bell
Communications Research, Inc. (Bellcore) and by RSA Data Security,
Inc. and bear similar copyrights and disclaimers of warranty.

