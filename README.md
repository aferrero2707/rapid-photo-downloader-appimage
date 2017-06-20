# How to build

The build environment for the GIMP AppImage is based on [jhbuild](https://github.com/GNOME/jhbuild).

However, there is no need to manually install jhbuild, as the build scripts will take care of that automatically.

The creation of the AppImage proceeds in three steps:

1. installation of Python 3.5 and jhbuild:

    ./bootstrap.sh
    
The bootstrap.sh command will ask for the root password in order to create the special /yyy folder under which all software will be installed

2. compilation of rapid-photo-downloader and all its dependencies with jhbuild:

    ./build.sh rpd

3. creation of the AppImage itself:

    ./mkappimage
    
The last two steps will download the source code on work/sources, install them under /yyy, and save the AppImage package in out/

# Dependencies

zlib (zlib1g-dev in Ubuntu),
perl (libpython-all-dev in Ubuntu),

# Credits

The AppImage uses the exec-wrapper originally developed by the KDE team:

    git://anongit.kde.org/scratch/brauch/appimage-exec-wrapper
    
It allows rapid-photo-downloader to spawn external commands with the original shell environment instead of the one proper to the AppImage itself. 
