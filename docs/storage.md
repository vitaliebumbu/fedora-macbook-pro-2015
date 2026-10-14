# Storage housekeeping

The camera test streamed 60 frames directly to `/dev/null`; no recording was saved. A storage check found approximately 99 GiB free on the 111 GiB root/home filesystem.

## Automatic cleanup

- Fedora's existing systemd tmpfiles timer cleans `/tmp` after 10 days and `/var/tmp` after 30 days, subject to its age and access rules.
- Existing weekly SSD TRIM remains enabled; TRIM is not file deletion or a replacement for cleanup.
- `storage/30-storage-limits.conf` caps persistent journal use at 256 MiB, leaves a 2 GiB free-space allowance, caps runtime journals at 64 MiB, and retains logs for at most 30 days. Active journal files can make usage temporarily exceed the nominal cap.
- `package-cache-clean.timer` runs weekly, with up to one hour random delay and catch-up after downtime. Its service runs only on AC power and executes `dnf clean all`. A skipped battery-only run waits for a subsequent timer trigger.
- `user-cache-clean.timer` performs weekly user DNF cache cleanup and user tmpfiles cleanup while the user manager is running.
- `thumbnail-cache.conf` removes thumbnail cache files unused for 30 days.
- GNOME old temporary-file cleanup was enabled with its existing 30-day age. Automatic Trash deletion was not enabled.

DNF metadata is regenerable and will be downloaded again when needed; weekly cleanup trades network traffic for space. No `keepcache` setting was enabled. Personal files, Downloads, browser sessions, application runtime caches, and installed packages are not deleted by the added jobs.

## Reproduce

Review existing files and back them up before installing these snippets:

```bash
sudo install -Dm644 storage/30-storage-limits.conf /etc/systemd/journald.conf.d/30-storage-limits.conf
sudo install -m644 storage/package-cache-clean.service storage/package-cache-clean.timer /etc/systemd/system/
sudo restorecon /etc/systemd/journald.conf.d/30-storage-limits.conf /etc/systemd/system/package-cache-clean.service /etc/systemd/system/package-cache-clean.timer
sudo systemctl daemon-reload
sudo systemctl restart systemd-journald
sudo systemctl enable --now package-cache-clean.timer
mkdir -p ~/.config/systemd/user ~/.config/user-tmpfiles.d
install -m644 storage/user-cache-clean.service storage/user-cache-clean.timer ~/.config/systemd/user/
install -m644 storage/thumbnail-cache.conf ~/.config/user-tmpfiles.d/
systemctl --user daemon-reload
systemctl --user enable --now user-cache-clean.timer
gsettings set org.gnome.desktop.privacy remove-old-temp-files true
```

Restore SELinux labels when placing files under `/etc`; copying home-file extended attributes can otherwise prevent systemd loading the units.

## Verification and recovery

Immediate system and user `dnf clean all` reclaimed approximately 105 + 275 MiB with zero reported errors. Both new timers were enabled; unit syntax checked. Future scheduled runs and thumbnail aging have not yet been observed.

Inspect with `systemctl list-timers package-cache-clean.timer` and `systemctl --user list-timers user-cache-clean.timer`. Undo by disabling those timers, removing only their added files and thumbnail rule, reloading the managers, and restoring previous journald and GNOME settings. Removed caches and expired logs are not recoverable from these configuration backups; cache metadata regenerates on demand.

Avoid automatic package autoremove, whole-home cache deletion, or removal of kernel fallback versions without reviewing what would be removed.
