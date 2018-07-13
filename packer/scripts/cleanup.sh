yum -y erase gtk2 libX11 hicolor-icon-theme avahi freetype bitstream-vera-fonts
yum -y clean all
rm -rf VBoxGuestAdditions_*.iso
rm -rf /tmp/rubygems-*

# Vagrant GuestAdditions が動くためのカーネル
#yum -y install http://vault.centos.org/6.4/cr/x86_64/Packages/kernel-devel-2.6.32-431.el6.x86_64.rpm
