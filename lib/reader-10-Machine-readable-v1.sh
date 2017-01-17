#!/bin/bash
#
#    Copyright 2016 Daniel Alder, https://github.com/daald
#
#    This file is part of dpkg-licenses.
#
#    dpkg-licenses was written by Daniel Alder, https://github.com/daald
#
#    dpkg-licenses is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    dpkg-licenses is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with dpkg-licenses.  If not, see <http://www.gnu.org/licenses/>.

# Description:
#   Parses /usr/share/doc/$package/copyright according to:
#   http://dep.debian.net/deps/dep5/

package="$1"
copyrightfile=
if [ -f "/usr/share/doc/$package/copyright" ]; then
  copyrightfile="/usr/share/doc/$package/copyright"
elif [ -f "/usr/share/doc/${package%:*}/copyright" ]; then
  copyrightfile="/usr/share/doc/${package%:*}/copyright"
else
  exit 0  # no copyright file found
fi

format=$(awk '/^Format:/{print}/^$/{exit}' "$copyrightfile")
[ -n "$format" ] || exit 0

case "$format" in
  *'://www.debian.org/doc/packaging-manuals/copyright-format/1.0'*)
    result=$(grep '^License:' "$copyrightfile" | cut -d':' -f2-)
    ;;
  *'http://dep.debian.net/deps/dep5'*)
    result=$(grep '^License:' "$copyrightfile" | cut -d':' -f2-)
    ;;
  *'http://anonscm.debian.org/viewvc/dep/web/deps/dep5.mdwn?'*)
    result=$(grep '^License:' "$copyrightfile" | cut -d':' -f2-)
    ;;
  *'http://svn.debian.org/wsvn/dep/web/deps/dep5.mdwn?'*)
    result=$(grep '^License:' "$copyrightfile" | cut -d':' -f2-)
    ;;
  *'http://anonscm.debian.org/loggerhead/dep/dep5/trunk/annotate/179/dep5/copyright-format.xml'*)
    result=$(grep '^License:' "$copyrightfile" | cut -d':' -f2-)
    ;;
  "Format:")  # seen in /usr/share/doc/libpcsclite1/copyright
    result=$(grep '^License:' "$copyrightfile" | cut -d':' -f2-)
    ;;
  *)
    echo "WARNING: Unknown format of $copyrightfile: $format" >&2
    exit 1  # unknown format
esac

if [ -n "$result" ]; then
  echo "$result" | sed -r -e 's/ and /\n/g' -e 's/^ +//' -e 's/ +$//' -e 's/icence/icense/g' | sort -u
fi

exit 0

