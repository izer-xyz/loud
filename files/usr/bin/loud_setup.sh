#!/bin/sh

echo Loud config utility
read -p "Host name: " LOUD_HOSTNAME
read -p "Wifi SSID: " LOUD_WIFI_SSID
read -p "Wifi Key: " LOUD_WIFI_KEY

# if partition doesn't exist -> new SD card
if [ "`find /dev -name mmcblk0p3`" == "" ]; then
  echo Create partition
  parted -a optimal /dev/mmcblk0 mkpart primary ext4 612M 100% 
  mkfs.ext4 -F /dev/mmcblk0p3 &>/dev/null
fi

# if mount doesn't exist
if [ "`grep '/mnt.$' /etc/config/fstab`" == "" ]; then
  echo Mount /mnt/ partition 
  mount /dev/mmcblk0p3 /mnt
  block detect | uci import fstab

  uci set fstab.@mount[-1].enabled='1'
  uci set fstab.@global[0].check_fs='1'
  
  uci commit fstab
fi

uci set system.@system[0].hostname="$LOUD_HOSTNAME"
uci set system.@system[0].timezone='AEST-10AEDT,M10.1.0,M4.1.0/3'

uci del dhcp.lan.ra_slaac                                        
uci set dhcp.lan.ra='hybrid'                                     
uci set dhcp.lan.dhcpv6='hybrid'                                 
                                                                 
uci del network.lan.ipaddr             
uci del network.lan.netmask            
uci del network.lan.ip6assign          
uci set network.lan.proto='dhcp'                   
                                                                 
uci set network.wlan=interface                                   
uci set network.wlan.proto='dhcp'                                
                                                                 
uci set wireless.default_radio0.mode='sta'                       
uci set wireless.default_radio0.encryption='psk2'     
uci set wireless.default_radio0.ssid="$LOUD_WIFI_SSID"
uci set wireless.default_radio0.key="$LOUD_WIFI_KEY"  
uci set wireless.default_radio0.network='wlan'

#uci set dockerd.globals.iptables=0
#uci set dockerd.globals.data_root='/mnt/docker/'
#uci add_list dockerd.globals.hosts=tcp://0.0.0.0:2375
#uci add_list dockerd.globals.hosts=unix:///var/run/docker.sock

uci set shairport-sync.shairport_sync.enabled=1
uci set shairport-sync.shairport_sync.name='%h'

uci set librespot.librespot.device_name="$LOUD_HOSTNAME"
uci set librespot.librespot.initial_volume=10

uci commit 

echo Set default volume 
amixer sset Digital 70%
alsactl store

echo reboot
reboot
