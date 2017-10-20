#!/bin/sh
set -e
set -x

echo "Additional configuration for ubuntu boxes"

if [ "$PACKER_BUILDER_TYPE" = "virtualbox-iso" ]; then
  echo "do $PACKER_BUILDER_TYPE specific provisioning"
  
  echo "Fix for Hyper-V black terminal: https://wellsie.net/p/395/"
  echo '@password@' | sudo -S sed -i 's/quiet splash//g' /etc/default/grub
  sudo sed -i 's/#GRUB_TERMINAL/GRUB_TERMINAL/g' /etc/default/grub
  sudo update-grub
fi