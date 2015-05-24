listenIP="127.0.0.1:69"
apt-get install tftpd-hpa
apt-get install dhcp3-server
apt-get install syslinux
#slightly different configuration for an internal subnet
echo "subnet 192.168.100.0 netmask 255.255.255.0 {" > /etc/dhcp/dhcpd.conf
echo "range 192.168.100.121 192.168.100.234;" >> /etc/dhcp/dhcpd.conf
echo "option domain-name-servers 192.168.100.254;" >> /etc/dhcp/dhcpd.conf
echo "option domain-name \"vvdomain.com\";" >> /etc/dhcp/dhcpd.conf
echo "option routers 192.168.100.1;" >> /etc/dhcp/dhcpd.conf
echo "option subnet-mask 255.255.255.0;" >> /etc/dhcp/dhcpd.conf
echo "option broadcast-address 192.168.100.255;" >> /etc/dhcp/dhcpd.conf
echo "default-lease-time 600;" >> /etc/dhcp/dhcpd.conf
echo "max-lease-time 7200;" >> /etc/dhcp/dhcpd.conf
echo "filename \"pxelinux.0\";" >> /etc/dhcp/dhcpd.conf
echo "}" >> /etc/dhcp/dhcpd.conf

#/etc/default/tftpd-hpa
sed -i "/^TFTP_ADDRESS=/cTFTP_ADDRESS=/cTFTP_ADDRESS=\"${listenIP}\"" /etc/default/tftpd-hpa

#/etc/default/isc-dhcp-server
sed -i "/^INTERFACES=/cINTERFACES=\"em1\"" /etc/default/isc-dhcp-server


#Create Pxelinux.cfg 
mkdir /var/lib/tftpboot/pxelinux.cfg/

#config default
echo "DEFAULT MENU" >> /var/lib/tftpboot/pxelinux.cfg/default 
echo "PROMPT 0" >> /var/lib/tftpboot/pxelinux.cfg/default 
echo "TIMEOUT 50" >> /var/lib/tftpboot/pxelinux.cfg/default 
echo "LABEL MEMU" >> /var/lib/tftpboot/pxelinux.cfg/default 
echo "Menu Label PXE BOOT" >> /var/lib/tftpboot/pxelinux.cfg/default
echo "Kernel menu.c32" >> /var/lib/tftpboot/pxelinux.cfg/default 
echo "LABEL Boothd" >>  /var/lib/tftpboot/pxelinux.cfg/default
echo "Menu label Local boot" >>  /var/lib/tftpboot/pxelinux.cfg/default
echo "Loacalboot 0" >>  /var/lib/tftpboot/pxelinux.cfg/default
echo "LABEL Fdboot" >>  /var/lib/tftpboot/pxelinux.cfg/default
echo "Menu Label Freedos" >>  /var/lib/tftpboot/pxelinux.cfg/default
echo "Kernel memdisk" >>  /var/lib/tftpboot/pxelinux.cfg/default
echo "Append initrd=fdboot.img ramdisk_size=14400" >>  /var/lib/tftpboot/pxelinux.cfg/default

#restart all-services
service tftpd-hpa restart
service isc-dhcp-server restart
