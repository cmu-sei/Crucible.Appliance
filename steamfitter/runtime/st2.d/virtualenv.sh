#!/bin/bash
EXAMPLES=/opt/stackstorm/packs/examples
VSPHERE=/opt/stackstorm/packs/vsphere
if [ ! -d "$EXAMPLES" ]; then
  echo "Installing examples..."
  cp -R /usr/share/doc/st2/examples /opt/stackstorm/packs
  chgrp -R st2packs /opt/stackstorm/packs/examples
  st2 run packs.setup_virtualenv packs=examples
fi
if [ ! -d "$VSPHERE" ]; then
  st2 pack install vsphere 
  st2 run packs.setup_virtualenv packs=vsphere
fi

