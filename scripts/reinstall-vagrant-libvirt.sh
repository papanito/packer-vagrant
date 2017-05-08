#!/bin/sh

# in case it's already installled
vagrant plugin uninstall vagrant-libvirt

# vagrant's copy of curl prevents the proper installation of ruby-libvirt
sudo mv /opt/vagrant/embedded/lib/libcurl.so{,.backup}
sudo mv /opt/vagrant/embedded/lib/libcurl.so.4{,.backup}
sudo mv /opt/vagrant/embedded/lib/libcurl.so.4.4.0{,.backup}
sudo mv /opt/vagrant/embedded/lib/pkgconfig/libcurl.pc{,.backup}

CONFIGURE_ARGS="with-libvirt-include=/usr/include/libvirt with-libvirt-lib=/usr/lib" vagrant plugin install vagrant-libvirt

# https://github.com/pradels/vagrant-libvirt/issues/541
export PATH=/opt/vagrant/embedded/bin:$PATH
export GEM_HOME=~/.vagrant.d/gems/2.2.5
export GEM_PATH=$GEM_HOME:/opt/vagrant/embedded/gems

gem uninstall ruby-libvirt
gem install ruby-libvirt

# put vagrant's copy of curl back
sudo mv /opt/vagrant/embedded/lib/libcurl.so{.backup,}
sudo mv /opt/vagrant/embedded/lib/libcurl.so.4{.backup,}
sudo mv /opt/vagrant/embedded/lib/libcurl.so.4.4.0{.backup,}
sudo mv /opt/vagrant/embedded/lib/pkgconfig/libcurl.pc{.backup,}