# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "libgb"
version = v"0.17-dev0"

# Collection of sources required to build libgb
sources = [
    "https://github.com/ederc/gb.git" =>
    "794f04d70cc9fc786f97f09bfb7440e6cddeb063",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd gb/
./autogen.sh 
./configure --enable-shared --disable-static --with-gmp=$prefix --prefix=$prefix --host=$target
make
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    MacOS(:x86_64),
    Linux(:x86_64, libc=:glibc)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libgb--no-undefined", Symbol(""))
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/GMP-v6.1.2-1/build_GMP.v6.1.2.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

