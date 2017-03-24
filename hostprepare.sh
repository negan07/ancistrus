#!/bin/sh
#
# ancistrus
#
# Netgear's Nighthawk Router Experience Distributed Project
#
# D7000
#
# https://github.com/negan07/ancistrus
#
#
# host system: ubuntu yakkety x86/64
# prepare the host system for developing
#

# ubuntu has dash posix compliant only default shell, faster than bash but with tiny command set
# e.g. += support is missing creating problem on making and many more
# switching from dash to bash (action is reversible)
# answer no to next question
# sudo dpkg-reconfigure
sudo dpkg-reconfigure -p critical dash

# update the system: it's recommended to enable main, universe, restricted & multiverse repositories
sudo apt-get update
sudo apt-get upgrade

# dev tools
sudo apt-get install gcc-multilib
sudo apt-get install libtool
sudo apt-get install gdb
sudo apt-get install make
sudo apt-get install automake
sudo apt-get install autoconf
sudo apt-get install binutils
sudo apt-get install build-essential
sudo apt-get install linux-headers-$(uname -r) 
sudo apt-get install bison
sudo apt-get install flex
sudo apt-get install perl
sudo apt-get install gperf
# workaround for toolchain's gawk mpfr_z_sub compile error
# uninstall gawk & install mawk
sudo apt-get remove --purge gawk
sudo apt-get install mawk

# some dev libraries
sudo apt-get install compat-lib*
sudo apt-get install libssl-dev
sudo apt-get install ncurses-dev
sudo apt-get install libncurses5
sudo apt-get install libncursesw5-dev:i386
sudo apt-get install libstdc++5:i386
sudo apt-get install liblzo2-dev
sudo apt-get install uuid-dev
sudo apt-get install libpam0g-dev
#sudo apt-get install makeinfo
sudo apt-get install texinfo
#sudo apt-get install makedepend
sudo apt-get install xutils-dev
sudo apt-get install intltool

# opkg compile support
sudo apt-get install libarchive-dev
sudo apt-get install libassuan-dev libgpg-error-dev libgpgme11-dev

# subversion/cvs support
sudo apt-get install subversion mercurial
sudo apt-get install cvs

# git support
sudo apt-get install git gitk git-gui

# github support
sudo apt-get install xclip
sudo apt-get install ssh-agent
sudo apt-get install gpg

# squashfs support
sudo apt-get install squashfs-tools

# lzma support
#sudo apt-get install lzma-source squashfs-source
sudo apt-get install lzma lzma-dev
sudo apt-get install lib32z1 lib32z1-dev

# little local optional webserver
#sudo apt-get install thttpd
sudo apt-get install lighttpd

# some optional libraries
sudo apt-get install libmpfr-dev
sudo apt-get install libmpfi-dev-common
sudo apt-get install libgmp-dev
sudo apt-get install libmpc-dev
sudo apt-get install libboost-dev
sudo apt-get install libmpfrc++-dev
sudo apt-get install libmath-mpfr-perl

# post install cleanup
sudo apt-get autoremove
sudo apt-get autoclean
sudo apt-get clean

