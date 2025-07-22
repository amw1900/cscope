#!/bin/sh -ex
#
# Regenerate the autotools-based build system.
#
# "autoreconf --install" runs libtoolize/aclocal/autoheader/automake/autoconf
# in the correct order and copies (not symlinks) any missing auxiliary helper
# files into the tree.  Because configure.in uses AC_CANONICAL_HOST, that set
# includes config.sub and config.guess, which ./configure needs to canonicalize
# the build platform.
autoreconf --force --install

# Safety net: guarantee config.sub/config.guess are present as real files even
# if autoreconf did not install them, so ./configure never dies with
# "cannot run ./config.sub".
auxdir=`automake --print-libdir 2>/dev/null || true`
for f in config.sub config.guess; do
	if [ ! -f "$f" ] && [ -n "$auxdir" ] && [ -f "$auxdir/$f" ]; then
		cp "$auxdir/$f" "$f"
		chmod +x "$f"
	fi
done
