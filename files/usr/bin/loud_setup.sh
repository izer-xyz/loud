#!/bin/sh

echo Loud config utility
read -p "Host name: " LOUD_HOSTNAME
read -p "Wifi SSID: " LOUD_WIFI_SSID
read -p "Wifi Key: " LOUD_WIFI_KEY

uci set system.@system[0].hostname="$LOUD_HOSTNAME"

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

#uci set librespot.librespot.device_name="$LOUD_HOSTNAME"

uci commit network
uci commit wireless
uci commit system

#uci commit librespot

service system reload
service network reload
#service librespot enable

reboot
