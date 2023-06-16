#!/bin/bash

if [ ! -f ./SConstruct ]; then
   echo "You are not running this script from the SkylightOS root directory. Please change to the SkylightOS root directory."
   exit 1
fi

if [ ! -x "$(command -v mdir)" ]; then
   echo "ERR: unable to find mtools"
   exit 1
fi

set -e

rm -f publish/skylight-installer.img

tools/check_mb.sh
if [ $(tools/update_osver.py read) == "fre" ]; then
   echo "ERR: fre installer builds are not supported"
   exit 1
elif [ $(tools/update_osver.py read) == "chk" ]; then
   cp installer/inst.img publish/skylight-installer.img
   mcopy -i publish/skylight-installer.img bin/ia32_chk/base/esos/chkernel.elf ::/
else
  echo "ERR: Unknown kernel type - corrupt osver.h?"
  exit 1
fi
