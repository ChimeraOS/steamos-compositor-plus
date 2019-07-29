### What is this?
This is a fork of the SteamOS compositor, currently based on version 1.35.
It includes out of the box 4k (3840x2160) support, allows adjusting resolution/refresh rate through a configuration file, hides the annoying color flashing on startup of Proton games and adds a fix for games that start in the background, including Dead Cells, The Count Lucanor, most Feral games and probably others.

### Installation

#### Arch Linux
Available as `steamos-compositor-plus` in the AUR.

#### SteamOS
Run the supplied `steamos-install.sh` script using the instructions below. This retrieves the latest pre-built binary release of the SteamOS compositor, and copies it across to the right location.

1. open a terminal
2. run: `wget https://raw.githubusercontent.com/alkazar/steamos-compositor/master/steamos-install.sh && sudo sh steamos-install.sh`
3. restart your system

This will replace `/usr/bin/steamcompmgr` and `/usr/bin/steamos/set_hd_mode.sh` with modified versions. The original files will be appended with `.original`.
If there is a SteamOS update, the modified files may be overwritten and the install script will need to be run again.

### Building from source
Should you wish to build from source instead of using the pre-built binaries, clone the repository and run
`autoreconf -i && ./configure && make`

### Configuration
Upon first run, a configuration file will be created at `~/.config/steamos-compositor-plus`.
You can modify this file to manually adjust the resolution and refresh rate.

The variables that can be defined in the configuration file are:
GOODMODES - an array of resolutions for the compositor to select from
GOODRATES - an array of refresh rates for the compositor to select from
STEAMCMD  - a string defining the full command line to be executed to start Steam (see /usr/bin/steamos-session for the default command)

### Usage
Add any options to the `steamcompmgr` command in `/usr/bin/steamos-session`.

The following additional options are available:

	-b    Disable game focus hack
	-p    Disable proton/wine color flash suppression hack
	-g    Enable debug logging for game focus and proton hacks
