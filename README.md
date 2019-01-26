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
To disable the game focus hack, add the `-b` option to the `steamcompmgr` command in `/usr/bin/steamos-session`. This can be useful for testing and confirming an affected game.
