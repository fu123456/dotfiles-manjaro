#!/bin/bash
#
# $ld: mtags 1.8 1998/02/19 04:08:24 kinnucan Exp $
#
# Usage:     mtags [-h | srcdir]
#
# Abstract:  This Bourne shell script produces an Emacs
#            tags file for Matlab source code. The tags file
#            contains tags for classes, interfaces, constructors,
#            methods, and variables.
#
# Options:   -h  Print usage.
#
#            -srcdir  Path of top-level directory containing
#                     Matlab source(*.m) files to be tagged.
#                     If omitted, this script tags files in
#                     the working directory and its subdirectories.
#
# By:        Jonathan Epstein (Jonathan_Epstein@nih.gov) based almost
#              entirely upon earlier work (in JDE) by
#            Paul Kinnucan
#            The MathWorks, Inc.
#      paulk@mathworks.com
#
# Thanks:    David Lim <david@ndc.com>
#            Michael Mirman <mmirman@mathworks.com>
#            Kent S. Gordon" <kgor@inetspace.com>
#
# Set this to the path of the etags executable if it is
# not in the shell path.
#!/bin/bash
#$Id: otags,v 1.8 1998/11/12 13:28:49 mstorti Exp $

# generates a TAGS file a set of Octave .m files for use with Emacs.
# Run as '$ otags' in the given octave directory and will generate a
# TAGS file.  If you want to include another directory add a line
# prior to the "*.m" line containing something like
#  `--include=/path/to/other/directory/TAGS" \'.

# Tags are generated for function names and for global variables. For
# global variables it doesn't work for more than one line og global
# variables.  :-(((

# Tags are also created for lines of the form '###key foobar' so that
# you can jump to this specific place just by typing
# `M-. foobar'. Note that tags are not generated for scripts so that
# you have to add a line by yourself of the form `###key
# <script-name>' if you want to jump to it. :-(

etags_dir="/Program Files/Emacs/emacs-19.34/bin/"

# Print help.
if [ "$1" = "-h" ] || [ "$1" = "-help" ] ||
   [ "$1" = "-usage" ]; then
    echo ""
    echo "usage: mtags [-h | srcdir]"
    echo ""
    echo "srcdir   Path of the Matlab source directory."
    echo ""
    echo "This command tags all public classes, interfaces,"
    echo "methods, and variables in the specified Matlab source"
    echo "hierarchy. If you do not specify a source directory,"
    echo "mtags searches the current directory and its"
    echo "subdirectories."
    echo ""
    exit 1
fi

# If not the help option, assume first (should be only) parameter
# is the source path. If no parameters, default to the working
# directory.
matlab_dir=${1-.}

# Ensure that Matlab source directory exists.
if [ ! -d $matlab_dir ]; then
    echo "Matlab source directory $matlab_dir not found."
    exit 1
fi

capital='A-Z'
letter='a-zA-Z_.'
digit='0-9'
ws='[ \t]'

primitive_type1='\<\(b\(oolean\|yte\)\|char\|double\|float\|int'
primitive_type2='\|long\|short\|void\)\>'
primitive_type="$primitive_type1$primitive_type2"
primitive_type_count=2

primitive_type3='\|long\|short\)\>'
primitive_type_no_void="$primitive_type1$primitive_type3"
primitive_type_no_void_count=2

identifier="\<\([$letter][$letter$digit]*\)\>"
identifier_count=1

class_type="\<\([$capital][a-zA-Z_$digit]*\)\>"
class_type_count=1

modifier1='\<\(abstract\|const\|final\|native\|'
modifier2='p\(r\(ivate\|otected\)\|ublic\)\|'
modifier3='s\(tatic\|ynchronized\)\|transient\|volatile\)\>'
modifier="$modifier1$modifier2$modifier3"
modifier_count=4

# Class patterns
class1="/^$ws*\<\(class\|interface\)\>$ws*$identifier/\2/"
class2="/^[^.*]*\($modifier$ws*\)*\<\(class\|interface\)\>$ws*$identifier/\7/"

# Constructor pattern
constructor="/^$ws*\($modifier$ws*\)*$class_type$ws*(/\6/"

# Pattern for methods that return primitive types, e.g.,
#
#   int[] foo()
#
method1="/^[^.*]*$primitive_type$ws*\(\[$ws*\]$ws*\)*$identifier$ws*(/\4/"

# Pattern for methods that return class types, e.g.,
#
#   Foo[] foo()
#
method2="/^[^.*]*$class_type$ws*\(\[$ws*\]$ws*\)*$identifier$ws*(/\3/"

# Pattern for matching primitive variable declarations.
var1a=".*$primitive_type_no_void$ws*\(\[$ws*\]$ws*\)*$identifier"
var1b="$ws*\(=\|;\)"
var1="/$var1a$var1b/\4/"

# Pattern for matching user-defined variable declarations.
var2a=".*$class_type$ws*\(\[$ws*\]$ws*\)*$identifier"
var2b="$ws*\(=\|;\)"
var2="/$var2a$var2b/\3/"

# Delete the old TAGS file.
# Note: the old file must be deleted because we have to run
# etags in
# etags will append everything to the old file.

if [ -f ${matlab_dir}/TAGS ]; then
    rm ${matlab_dir}/TAGS
    echo "Removed old TAGS file."
fi

# Use find to recurse through the source hierarchy,
# finding every Matlab source file.
# Use xargs to apply etags to the source files.
# Note that xargs may invoke etags multiple
# times, depending on how many files it can batch
# per invocation. That is why we run etags in
# append (-a) mode.

#  echo "Tagging classes and constructors"
#  echo find $matlab_dir \( -name RCS -prune \) -o \( -name '*.m' -print \) \|
xargs  \
#  ${etags_dir}etags  -a -o ${matlab_dir}/TAGS  \
#  "--regex=$class1" "--regex=$class2"  "--regex=$constructor"
#  find $matlab_dir \( -name RCS -prune \) -o \( -name '*.m' -print \) | xargs
\
#  ${etags_dir}etags  -a -o ${matlab_dir}/TAGS  \
#  "--regex=$class1" "--regex=$class2"  "--regex=$constructor"

#  echo "Tagging methods"
#  find $matlab_dir \( -name RCS -prune \) -o \( -name '*.m' -print \) | xargs
\
#  ${etags_dir}etags  -a -o ${matlab_dir}/TAGS  \
#  "--regex=$method1" "--regex=$method2"

#  echo "Tagging variables"
#  find $matlab_dir \( -name RCS -prune \) -o \( -name '*.m' -print \) | xargs
\
#  ${etags_dir}etags  -a -o ${matlab_dir}/TAGS  \
#  "--regex=$var1" "--regex=$var2"

find $matlab_dir \( -name RCS -prune \) -o \( -name '*.m' -print \) | xargs  \
"${etags_dir}etags"  -a -o ${matlab_dir}/TAGS  \
      --lang=none \
      --regex='/function \([a-zA-Z][a-zA-Z0-9]+\)[^ =]/' \
      --regex='/[ \t]*function.*=[ \t]*\([^ \t]*\)[ \t]*(/\1/' \
      --regex='/###key \(.*\)/\1/' \
      --regex='/[ \t]*global[ \t].*/'


# History:
#
# $Log: mtags $
# Revision 1.8  1998/02/19 04:08:24  kinnucan
# More edits to the comments.
#
# Revision 1.7  1998/02/19 03:45:03  kinnucan
# Cleaned up the comments.
#
# Revision 1.6  1998/02/19 03:42:05  kinnucan
# "Kent S. Gordon" <kgor@inetspace.com> contributed the following
# improvements
#
#  - Change some .* expressions to [^.*] to prevent matches
#    in source file comments and functions.
#
#  - Removed . from class_type since declarations should never
#    be for another package.
#
# Thanks Kent.
#
# Revision 1.5  1997/12/03 03:31:29  kinnucan
# Divided tagging process into three passes
# through the source hierarchy to avoid overflowing
# the xargs bugger.
#
# Revision 1.4  1997/10/06 04:48:58  kinnucan
# Replaced existing regular expressions with a new set
# based on those contained in andersl-java-font-lock.el
#
# Revision 1.3  1997/08/26 09:10:44  kinnucan
# Added revision number.
#
# Revision 1.2  1997/08/26 09:02:42  kinnucan
# 1. Exclude RCS directories from tags search.
# 2. Added regular expression for abstract classes.
#
#

# End of mtags script.
