#!/bin/bash
for i in `ls /dev/disk/by-path`; do
  if [ ! -e /dev/disk/by-path/"$i" ] ; then echo Broken symlink: $i; exit 1; fi
done

cd /etc/libvirt/qemu
if [ ! -z `grep 360002ac *.xml | cut -b 42-86 | sort | uniq -c | egrep -v ^\ *1 || true` ]; then 
  echo Volume mounted to multiple VMs!
  exit 2
fi
