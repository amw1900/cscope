# cscope

A curses-based source-browsing tool for C (and lex/yacc, with partial C++).

> This is a fork of cscope 15.9 (originally open sourced by The Santa Cruz
> Operation (SCO) and subsequently maintained at <http://cscope.sourceforge.net>)
>
> List of updates: [Changes in this fork](#changes-in-this-fork).

## What it does

Cscope quickly finds where symbols are used and defined. It answers questions like:

- Where is this variable used?
- What is the value of this preprocessor symbol?
- Where is this function defined?
- What functions call this function? / are called by it?
- Where does the message `"out of space"` come from?
- Where is this source file in the tree? / What files include this header?

## Build & install

Quick start from a git checkout:

```sh
./autogen.sh      # needs: autoconf, automake, flex, bison/byacc
./configure       # needs: C compiler, make, ncurses-devel
make
sudo make install
```

Runtime: the change/replace feature uses the `ed` line editor (`yum install ed`).
Full details in [INSTALL.md](INSTALL.md).

## Python support (optional)

Cscope does not parse Python. The helper script `contrib/mkcst` (which builds a
database over a source tree) integrates
[pycscope](https://github.com/portante/pycscope) to index Python properly.
Install it once — it is an optional, external tool that `mkcst` invokes, not
bundled with cscope:

```sh
pip install --user git+https://github.com/portante/pycscope
```

Install from GitHub, **not** PyPI: the last PyPI release (1.2.1) predates
Python 3 and crashes when reading a file list (`AttributeError: module
'string' has no attribute 'rstrip'`); upstream master (1.2.3) is fixed.

pycscope parses with the running Python interpreter, so files using
Python-2-only syntax are skipped (`mkcst` logs these to `/tmp/pycscope.log`).
Expect gaps in a mixed Python 2 / Python 3 tree.

`mkcst` auto-detects `pycscope` on your `PATH`. When present, Python sources are
indexed into a separate `cscope_py.out` database instead of being lexed (poorly)
as C. Load both databases in your editor (vim) to search C and Python together:

```vim
:cs add cscope.out
:cs add cscope_py.out
```

When using vim, cscope_py.out can be added automatically via .vimrc.
Add something similar to the block below in an `if has("cscope")` block,
after the loop that walks the directory tree upward to set mypath.
```vim
    if (mypath != "")
        exe "cs add ".mypath."/cscope.out ".mypath

        if filereadable(mypath."/cscope_py.out")
            exe "cs add ".mypath."/cscope_py.out ".mypath
        endif
    endif
```

If pycscope is not installed, `mkcst` indexes `*.py` files as C and prints a
note on pycscope installation.

## Changes in this fork

Enhancements and fixes over stock cscope 15.9:

- Find global definitions inside extern "C" { … } blocks
```
    #ifdef __cplusplus
    extern "C" {
    #endif
```
- New keywords: inline and constexpr
- Recognize `|` and `(` in regex search
- Minimal recognition of C++ qualified names (Foo::bar): Search for bar
- Deprecate ancient header conditional compilation
- Transition to strlcpy/strlcat
- Fixed file and memory management leaks/bugs
- Fixed "File does not have expected format" error when text-search results exceed buffer limit
- Fixed keyword search: Now reports "not a C symbol" instead of failing as a malformed result
- Added `contrib/mkcst` helper: build a database over a source tree, with optional Python indexing via pycscope

```
    mkcst --help
    usage: mkcst [-i|--stdhdr] [-n|--nopycscope] [-t|--tags]
        -i, --stdhdr      Add /usr/include and /usr/local/include to the database
        -n, --nopycscope  Skip pycscope check, do not build a pycscope database
        -t, --tags        Generate per-directory 'tags' files (via ctags)
```

## License

BSD — see [COPYING](COPYING).

## Security note

This is ancient Unix software that predates modern security concerns. It is not
hardened; it is intended for use by developers, not administrators or anonymous
users.

## More history

Joe Steffen was the original author of cscope. Steffen began developing the tool
at AT&T Bell Labs in the early 1980s as a personal utility to navigate code more
efficiently on a PDP-11.

It was originally a collection of shell scripts before being rewritten as a
C program with a tagged database because the shell scripts didn't perform well
large codebases.

The tool became extremely popular within Bell Labs and developers, and Steffen
was inundated with feature requests.

AT&T bundled cscope with the Official AT&T UNIX System V distribution (around
Release 4 / Version 12). As it was tied to the commercial UNIX source code,
cscope followed the corporate acquisitions as the rights to UNIX System V
repeatedly changed hands.

- AT&T spun-off UNIX System Laboratories (USL) between 1989 and 1991
- Novell acquired USL in 1993
- The Santa Cruz Operation (SCO) acquired UnixWare from Novell in 1995

Following the rise of open source operating systems, like Linux and FreeBSD,
in the late 1990s, SCO released the cscope source code, as open source
software, under a BSD license.

Petr Sorfa (SCO) ported cscope to Linux (building under gcc) and published
the source code on SourceForge. Maintenance was subsequently picked up by
Hans-Bernhard Bröker and Neil Horman.

