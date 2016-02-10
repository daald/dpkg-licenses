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
#   fuzzy search for known licence names

set -e

package="$1"
copyrightfile=
if [ -f "/usr/share/doc/$package/copyright" ]; then
  copyrightfile="/usr/share/doc/$package/copyright"
elif [ -f "/usr/share/doc/${package%:*}/copyright" ]; then
  copyrightfile="/usr/share/doc/${package%:*}/copyright"
else
  exit 0  # no copyright file found
fi

result=$(grep -Ewoi \
    -e '(4-?clause )?"?BSD"? licen[sc]es?' \
    -e '(Boost Software|mozilla (public)?|MIT) Licen[sc]es?' \
    -e '(CCPL|BSD|L?GPL)-[0-9a-z.+-]+( Licenses?)?' \
    -e 'Creative Commons( Licenses?)?' \
    -e 'Public Domain( Licenses?)?' \
    "$copyrightfile" | sed -r -e 's/[Ll]icence/License/g' | sort -u)
if [ -n "$result" ]; then
  echo "$result"
fi

exit 0

