#! /bin/bash

mv /usr/bin/steamcompmgr /usr/bin/steamcompmgr.original
wget https://github.com/alkazar/steamos-compositor/releases/download/1.1.2/steamcompmgr
mv steamcompmgr /usr/bin/steamcompmgr
chmod a+x /usr/bin/steamcompmgr
