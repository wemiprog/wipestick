#!/bin/bash

cd main
chmod +x build.sh
chmod +x airootfs/root/customize_airootfs.sh
chmod +x airootfs/root/.automated_script.sh
chmod +x airootfs/etc/systemd/scripts/choose-mirror

./build.sh -v
cp out/*.iso ../
