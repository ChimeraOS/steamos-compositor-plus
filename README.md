### What is this?
This is a fork of the SteamOS compositor, currently based on version 1.35.
It includes out of the box 4k (3840x2160) support, hides the annoying color flashing on startup of Proton games and adds a fix for games that start in the background, including Dead Cells, The Count Lucanor, most Feral games and probably others.

### Installation

#### Arch
Available as `steamos-compositor-plus` in the AUR.

#### SteamOS
Run the supplied `steamos-install.sh` script using the instructions below. This retrieves the latest pre-built binary release of the SteamOS compositor, and copies it across to the right location.

1. open a terminal
2. run: `wget https://raw.githubusercontent.com/alkazar/steamos-compositor/master/steamos-install.sh && sudo sh steamos-install.sh`
3. restart your system

This will replace `/usr/bin/steamcompmgr` with a modified version. The original file will be moved to `/usr/bin/steamcompmgr.original`.
If there is a SteamOS update, `/usr/bin/steamcompmgr` may be overwritten and the install script will need to be run again.

### Building from source
Should you wish to build from source instead of using the pre-built binaries, clone the repository and run
`autoreconf -i && ./configure && make`

### Usage
Add any options to the `steamcompmgr` command in `/usr/bin/steamos-session`.

The following additional options are available:

	-b    Disable game focus hack
	-p    Disable proton/wine color flash suppression hack
	-g    Enable debug logging for game focus and proton hacks
