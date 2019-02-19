### What is this?
This is a fork of the SteamOS compositor, currently based on version 1.35.
It includes out of the box 4k (3840x2160) support and adds a fix for games that start in the background, including Dead Cells, The Count Lucanor, Mirror's Edge (Steam Play), most Feral games and probably others. 

### Build
Clone the repository and run
`autoreconf -i && ./configure && make`

### Installation
#### Arch
Available as `steamos-compositor-plus` in the AUR.

#### SteamOS
Coming soon.

### Usage
Add any options to the `steamcompmgr` command in `/usr/bin/steamos-session`.

The following additional options are available:
	-b    Disable game focus hack
	-p    Disable proton/wine color flash suppression hack
	-g    Enable debug logging for game focus and proton hacks
