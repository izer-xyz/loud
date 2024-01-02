# Loud
OpenWRT image for a Wifi speaker

 * [ ] Minimal image
 * [ ] RPi (zero?) 
 * [ ] DAC support (https://shop.justboom.co/products/justboom-amp-zero-phat)

       ```
       dtoverlay=i2s-mmap
       dtoverlay=justboom-dac
       ```

 * [ ] Wifi config
 * [ ] Spotify
   * Decision docker VS host ?   

References:
 * https://openwrt.org/docs/guide-user/hardware/audio/usb.audio 
 * [openwrt-imagebuilder-action](https://github.com/izer-xyz/openwrt-imagebuilder-action)
 * Build librespot - https://gist.github.com/michcioperz/99b40b861b158e2cbff507288d804c6b
 * Build rust library - https://blog.dend.ro/building-rust-for-routers/
