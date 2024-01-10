# Loud
OpenWRT image for a Wifi speaker

 * [x] Minimal image - [config](config#L6)
 * [x] RPi (3+) - [config](config#L2)
 * [x] DAC support - [10_enable_justboom-dac_hat](files/etc/uci-defaults/10_enable_justboom-dac_hat)
   * https://shop.justboom.co/products/justboom-amp-zero-phat
 * [x] Wifi config
   * Initial / setup - [30_wifi_enable](files/etc/uci-defaults/30_wifi_enable)
   * Client - [loud_setup.sh](files/usr/bin/loud_setup.sh#L30)
 * [x] Spotify - https://github.com/izer-xyz/librespot-openwrt
 * [x] Airplay - shairplay-sync
 * [x] Dockerd - not used / future use

## Usage 

TBD

## Troubleshooting

 * Debug via Console cable: 
   * The red lead should be connected to 5V if you want to power via the cable, see below for details
   * The black lead to GND (3rd pin down)
   * The white lead to TXD on the Pi (4th pin down)
   * The green lead to RXD on the pI (5th pin down)
  
## References:
 * https://openwrt.org/docs/guide-user/hardware/audio/usb.audio 
 * [openwrt-imagebuilder-action](https://github.com/izer-xyz/openwrt-imagebuilder-action)
 * Build librespot - https://gist.github.com/michcioperz/99b40b861b158e2cbff507288d804c6b
 * Build rust library - https://blog.dend.ro/building-rust-for-routers/
