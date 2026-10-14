# BCM43602 Wi-Fi stability in Power Saver

The previous boot logged repeated `brcmf_msgbuf_tx_ioctl: Failed to reserve space in commonring` and scan error `-12`, consistent with a failed driver/firmware command path. User reported no networks after reboot while in Power Saver. The same boot also had a suspend/resume event before the failures; trigger attribution remains uncertain.

The working adapter uses `brcmfmac`, not the proprietary wl driver. TuneD powersave's script enabled Wi-Fi power saving, confirmed by `iw dev wlp3s0 get power_save`.

## Targeted preventive test

Created `macbook-powersave` inheriting TuneD powersave CPU settings, but overriding its startup script to disable Wi-Fi power saving. Mapped `power-saver=macbook-powersave` in `/etc/tuned/ppd.conf`. Added a NetworkManager default `wifi.powersave=2` (disabled). Existing connection-specific settings may override NetworkManager defaults; TuneD also disables the live setting.

Source snippets are in `wifi/`. Install the profile files under `/etc/tuned/profiles/macbook-powersave/`, the NetworkManager snippet under `/etc/NetworkManager/conf.d/`, back up and edit the TuneD power-saver mapping, restore SELinux labels, and reload services. Do not replace unrelated profile mappings or Wi-Fi configuration.

Verified afterward: custom profile active, Wi-Fi power saving off, interface connected, CPU `no_turbo=1`. No module unload, network disconnection, or suspend test was performed. Reboot and repeated idle/suspend tests remain necessary. This workaround is not a proven fix; leaving Wi-Fi awake may increase battery use.

Rollback: restore previous TuneD mapping and profile choice, remove only the added profile/snippet, reload services, and restore prior Wi-Fi power-saving behavior. Local prior mapping backup is under `/var/lib/macbook-wifi-backup-*`.

References: [NetworkManager powersave values](https://networkmanager.pages.freedesktop.org/NetworkManager/NetworkManager/settings-802-11-wireless.html), [same-model Reddit report](https://www.reddit.com/r/linux_on_mac/comments/1jsql6h/), [BCM43602 community workaround for a different MacBook model](https://github.com/animatek/macbook-bcm43602-linux). Community reports are leads, not proof of the cause on this machine; no third-party scripts or CPU-offlining workaround were installed.
