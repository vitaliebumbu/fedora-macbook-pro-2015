# Touchpad scrolling

Fedora 44 GNOME Wayland uses the built-in `bcm5974` touchpad. Natural scrolling, two-finger scrolling, tap-to-click, finger click method and disable-while-typing were already enabled. Pointer speed remains 0.0.

To reduce overly fast two-finger scrolling across applications, installed the MIT-licensed [gascroll library](https://github.com/ls41/gascroll), source revision `b89f16fcb2ec863426418742c87e5e4f5a857b60`. Source and license are preserved in `touchpad/`. No extension or browser add-on installed. This is a third-party compositor workaround, not a native GNOME scroll-speed setting.

Run `touchpad/install.sh` as your desktop user (requires gcc). It builds a local library and adds a dedicated drop-in to GNOME Shell's Fedora `org.gnome.Shell@user.service`. Existing unrelated drop-ins are retained. Initial factor is 0.50 and the device filter is `bcm5974`, so mouse devices do not match. Natural direction, pointer acceleration and gestures are unchanged.

**Log out and back in once to activate.** Save work first. The current session was not restarted. After activation, edit `factor=` in `~/.config/gascroll.conf`: 0.50 means half speed; 1.00 restores the original speed. Edits are reread approximately once per second. To disable live, set `enabled=0`. For removal run `touchpad/uninstall.sh`, then log out/in. The disabled library/config are retained for recovery.

Verification on 2026-10-14: library compiled with warnings enabled, upstream configuration/live-reload self-test passed, installed factor verified as 0.50, and systemd unit environment includes the expected library/config paths. Actual session injection, physical scrolling feel, mouse isolation and login reliability remain pending until login and hardware testing. No claim of reproducing macOS momentum or application scrolling exactly.

After login, verify `libgascroll.so` appears in `/proc/$(pgrep -x gnome-shell)/maps` and look for `[gascroll]` lines in the GNOME Shell user journal after scrolling. If a login problem occurs, remove `~/.config/systemd/user/org.gnome.Shell@user.service.d/60-touchpad-scroll.conf` from a text console and log in again.
