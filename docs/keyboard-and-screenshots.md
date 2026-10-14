# Keyboard and screenshot shortcuts

## Top-row keys without Fn

`keyboard/hid_apple.conf` sets `options hid_apple fnmode=1`. The live value was checked and was `1`.

- F1/F2: display brightness.
- F5/F6: keyboard backlight.
- F7/F8/F9: previous, play/pause, next media controls.
- F10/F11/F12: mute, volume down, volume up.
- Hold Fn when you want the corresponding F1–F12 function key.

F3/F4 desktop actions depend on GNOME bindings; they were not separately tested in this snapshot. Fn+Backspace and Fn+Arrow combinations are independent of this setting.

```bash
sudo bash keyboard/install.sh
cat /sys/module/hid_apple/parameters/fnmode
```

The script rebuilds the running kernel's initramfs. If booting a different installed kernel, rebuild that initramfs as well:

```bash
sudo dracut --force --kver TARGET_KERNEL_RELEASE
```

To undo: `sudo bash keyboard/uninstall.sh`. Back up any pre-existing `hid_apple.conf` first because the original installer replaces that file.

## Screenshot shortcuts

With the optional Command/Control swap below, physical Command sends **Control** and physical Control sends **Super**. Option remains **Alt**. The screenshot installer includes both modifier variants to retain the same physical Command shortcuts. Recorded bindings:

| Shortcut | Action |
| --- | --- |
| Command + Shift + 3 | Capture the whole screen |
| Command + Shift + 4 | Open the screenshot selection interface |
| Command + Shift + 5 | Open the screenshot selection interface |
| Command + Shift + Option + 4 | Capture the active window |

No Fn key is needed. Existing Print, Shift+Print, and Alt+Print bindings are preserved.

```bash
bash screenshots/install.sh
```

Run as your desktop user, without sudo. The script saves existing GNOME shell keybindings under `~/.local/state/fedora-macbook-pro-2015/` before setting the three bindings. Review the saved dconf file before restoring it with `dconf load /org/gnome/shell/keybindings/ < BACKUP_FILE`; this restores all bindings in that saved subtree.

Bindings were read from GNOME; capturing screenshots with the physical keyboard was not tested during publication.

## Command copy, paste, and print

The optional `keyboard/command-shortcuts.conf` enables the Apple driver parameter `swap_ctrl_cmd=1`, swapping Command and Control on Apple keyboards. It is separate from the Fn configuration so the original Fn installer cannot overwrite it.

```bash
sudo bash keyboard/install-command-shortcuts.sh
bash screenshots/install.sh
```

| Physical keys | Action in normal applications |
| --- | --- |
| Command + C | Copy |
| Command + V | Paste |
| Command + X | Cut |
| Command + P | Print |
| Command + A | Select all |
| Command + Z | Undo |

Terminals usually use **Command+Shift+C/V** for copy/paste after this swap. Command+C remains the terminal interrupt. The physical Control key now invokes GNOME Super shortcuts (for example Control+L locks the screen). This is a driver-level modifier swap, not application-specific shortcut emulation.

Applied live on 2026-10-13; the runtime value was verified as `1` and the running kernel initramfs was rebuilt. Physical application copy/paste and reboot persistence remain untested. Screenshot bindings were updated to preserve physical Command+Shift+3/4/5 and Command+Shift+Option+4.

To undo, remove `/etc/modprobe.d/hid_apple-command.conf`, write `0` to `/sys/module/hid_apple/parameters/swap_ctrl_cmd` with administrator access, and rebuild the running kernel initramfs. Keep the Fn configuration. Remove only the added Control screenshot bindings if desired, preserving other custom bindings.
