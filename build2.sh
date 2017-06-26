#! /bin/bash

install_prefix=yyy

mkdir -p work
cd work

WD=$(pwd)
prefix=$WD/inst

export PATH=/${install_prefix}/bin:$prefix/bin:$PATH
export LD_LIBRARY_PATH=/${install_prefix}/lib:$prefix/lib:$LD_LIBRARY_PATH

export CHECKOUTROOT=$WD/sources
export BUILDROOT=$WD/build

export ACLOCAL_FLAGS="-I /yyy/share/aclocal"

which python
which pip

jhbuild -f "$WD/../rpd.jhbuildrc" -m "$WD/../modulesets/rpd.modules" build $*
