#! /bin/bash

install_prefix=yyy

if [ ! -e /${install_prefix} ]; then
    username=$(whoami)
    groupname=$(id -gn $username)
    sudo mkdir -p /${install_prefix}
    sudo chown -R $username:$groupname /${install_prefix}
fi

mkdir -p work
cd work

WD=$(pwd)
prefix=$WD/inst

export PATH=/${install_prefix}/bin:$prefix/bin:$PATH
export LD_LIBRARY_PATH=/${install_prefix}/lib:$prefix/lib:$LD_LIBRARY_PATH

if [ ! -e "/${install_prefix}/bin/python3" ]; then
    (rm -rf Python-3.5.3* && wget https://www.python.org/ftp/python/3.5.3/Python-3.5.3.tar.xz && tar xJvf Python-3.5.3.tar.xz && cd Python-3.5.3 && ./configure --prefix=/${install_prefix} --enable-shared --enable-unicode=ucs2 && make && make install)
    (cd /${install_prefix}/bin && rm -f python python-config && ln -s python3 python && ln -s python3-config python-config)
fi

#exit

if [ ! -e "$prefix/bin" ]; then
    (rm -rf jhbuild && git clone https://github.com/GNOME/jhbuild.git && cd jhbuild && ./autogen.sh --prefix=$prefix && make && make install)
fi

(cd "$prefix/bin" && rm -f automake-1.11 && ln -s $(which automake) automake-1.11)



export CHECKOUTROOT=$WD/sources
export BUILDROOT=$WD/build

jhbuild -f "$WD/../rpd.jhbuildrc" -m "$WD/../modulesets/rpd.modules" build gettext
#jhbuild -f "$WD/../rpd.jhbuildrc" -m "$WD/../modulesets/rpd.modules" build python2

jhbuild -f "$WD/../rpd.jhbuildrc" -m "$WD/../modulesets/rpd.modules" build qt
