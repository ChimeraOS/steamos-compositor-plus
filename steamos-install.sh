#! /bin/bash

set -e

ver=1.1.2

function xinstall {
	src=$1
	dest=$2

	mv $dest $dest.original
	wget --quiet $src
	mv `basename $src` $dest
	chmod a+x $dest
}

xinstall \
	https://github.com/alkazar/steamos-compositor/releases/download/$ver/steamcompmgr \
	/usr/bin/steamcompmgr

xinstall \
	https://raw.githubusercontent.com/alkazar/steamos-compositor/$ver/usr/bin/steamos/set_hd_mode.sh \
	/usr/bin/steamos/set_hd_mode.sh

echo "Installation complete. Please restart the system for changes to take effect."
