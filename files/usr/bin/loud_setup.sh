#!/bin/sh

echo Loud config utility
read -p "Host name: " LOUD_HOSTNAME
read -p "Wifi SSID: " LOUD_WIFI_SSID
read -p "Wifi Key: " LOUD_WIFI_KEY

# if partition doesn't exist -> new SD card
if [ "`find /dev -name mmcblk0p3`" == "" ]; then
  parted -a optimal /dev/mmcblk0 mkpart primary ext4 612M 100% 
  mkfs.ext4 -F /dev/mmcblk0p3 &>/dev/null
fi

# if mount doesn't exist
if [ "`grep '/mnt' /etc/config/fstab`" == "" ]; then
  mount /dev/mmcblk0p3 /mnt
  block detect | uci import fstab

  uci set fstab.@mount[-1].enabled='1'
  uci set fstab.@global[0].check_fs='1'
  
  uci commit fstab
fi

uci set system.@system[0].hostname="$LOUD_HOSTNAME"
uci set system.@system[0].timezone='AEST-10AEDT,M10.1.0,M4.1.0/3'

uci set network.wlan=interface
uci set network.wlan.proto='dhcp'

uci del wireless.default_radio0

uci set wireless.wifinet1=wifi-iface
uci set wireless.wifinet1.device='radio0'
uci set wireless.wifinet1.mode='sta'
uci set wireless.wifinet1.network='wlan'
uci set wireless.wifinet1.encryption='psk2'
uci set wireless.wifinet1.ssid="$LOUD_WIFI_SSID"
uci set wireless.wifinet1.key="$LOUD_WIFI_KEY"

uci set dockerd.globals.data_root='/mnt/docker/'

uci commit 

service system reload
service network reload

service dockerd restart

echo waiting 7s for docker to restart
sleep 7

docker load --input /opt/loud/docker-images.tar
docker stack up --compose-file /opt/loud/docker-compose.yml loud

echo "Recommended to <reboot> the system." 
