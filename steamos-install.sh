#! /bin/bash

set -e

ver=1.2.0

function xinstall {
	src=$1
	dest=$2

	mv $dest $dest.original
	wget --quiet $src
	mv `basename $src` $dest
	chmod a+x $dest
}

xinstall \
	https://github.com/gamer-os/steamos-compositor/releases/download/$ver/steamcompmgr \
	/usr/bin/steamcompmgr

xinstall \
	https://raw.githubusercontent.com/gamer-os/steamos-compositor/$ver/usr/bin/steamos/set_hd_mode.sh \
	/usr/bin/steamos/set_hd_mode.sh

xinstall \
	https://raw.githubusercontent.com/gamer-os/steamos-compositor/$ver/usr/bin/steamos-session \
	/usr/bin/steamos-session

echo "Installation complete. Please restart the system for changes to take effect."
