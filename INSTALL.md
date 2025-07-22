# Installing cscope

## Quick start (from a git checkout)

```sh
./autogen.sh      # requires: autoconf, automake, flex, bison/byacc
./configure       # requires: C compiler, make, ncurses-devel
make
sudo make install
```

> **Note:** also install the runtime dependencies below.

If you are building from a release tarball (`make dist` output) rather than a
git checkout, the tree is already bootstrapped — skip `./autogen.sh` and start
at `./configure`.

## Build prerequisites

| Step | Requires |
|------|----------|
| `./autogen.sh` (git checkout only) | autoconf, automake, flex, bison/byacc |
| `./configure` + `make` | C compiler, make, ncurses-devel |

## Runtime dependencies

The change/replace feature (the "Change" input field) generates an `ed` script,
so it requires the **ed** line editor:

```sh
yum install ed      # or: dnf install ed
```

## Configure options

`./configure` accepts the usual GNU autoconf options (`--prefix`, etc.). Run
`./configure --help` for the full list. See [INSTALL.gnu](INSTALL.gnu) for the
generic GNU installation instructions.
