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
export PKG_CONFIG_PATH=/${install_prefix}/lib/pkgconfig:$prefix/lib:$PKG_CONFIG_PATH

if [ ! -e "/${install_prefix}/bin/python3" ]; then
    (rm -rf Python-3.5.3* && wget https://www.python.org/ftp/python/3.5.3/Python-3.5.3.tar.xz && tar xJvf Python-3.5.3.tar.xz && cd Python-3.5.3 && ./configure --prefix=/${install_prefix} --enable-shared --enable-ipv6 --enable-loadable-sqlite-extensions --with-threads --without-ensurepip && make && make install)
    (cd /${install_prefix}/bin && rm -f python python-config && ln -s python3 python && ln -s python3-config python-config)
fi

#(cd Python-3.5.3 && make && make install)

if [ ! -e "$prefix/bin" ]; then
    (rm -rf jhbuild && git clone https://github.com/GNOME/jhbuild.git && cd jhbuild && ./autogen.sh --prefix=$prefix && make && make install)
fi

export CHECKOUTROOT=$WD/sources
export BUILDROOT=$WD/build

python -c "import ssl; print(ssl.OPENSSL_VERSION)"

jhbuild -f "$WD/../rpd.jhbuildrc" -m "$WD/../modulesets/rpd.modules" build util-linux libgphoto2 gexiv2 gst-plugins-base libraw libmediainfo exiftool

rm -f get-pip.py
wget https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py

export PYTHONUSERBASE=/${install_prefix}
#python3 install.py rapid-photo-downloader-0.9.0b7.tar.gz
which pip
pip install --user -ignore-installed setuptools pyqt5 
pip install --user -ignore-installed -r ../requirements.txt

jhbuild -f "$WD/../rpd.jhbuildrc" -m "$WD/../modulesets/rpd.modules" build pygobject gexiv2 rawkit

#pip install --user -ignore-installed ../rapid-photo-downloader-0.9.0.tar.gz
#exit

rm -rf rapid-photo-downloader-0.9.0b7.tar.gz rapid
bzr_cmd=$(which bzr)
if [ x"${bzr_cmd}" != "x" ]; then
    bzr branch lp:rapid
    cd rapid
    python3 setup.py sdist
    cd ..
    #pip install --user -ignore-installed ../rapid-photo-downloader-0.9.0.tar.gz
    pip install --user -ignore-installed rapid/dist/rapid-photo-downloader-0.9.0.tar.gz
else
    wget https://launchpad.net/rapid/pyqt/0.9.0b7/+download/rapid-photo-downloader-0.9.0b7.tar.gz
    pip install --user -ignore-installed rapid-photo-downloader-0.9.0b7.tar.gz
fi
