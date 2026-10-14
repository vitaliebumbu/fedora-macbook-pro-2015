# Idle display and suspend

Configured on2026-10-14: GNOME display blanking after30 minutes of inactivity, automatic suspend after45 minutes on both battery and AC. Run `power/set-idle-timeouts.sh` as the desktop user to restore persistent dconf settings. Previous values were300 seconds for display and900 seconds for suspend. Settings read back as1800/2700/2700; actual timed behavior not observed. Applications that inhibit idle/sleep can delay these actions.

Existing logind lid policy retained: close lid suspends on battery/AC, docked lid closure ignored. These are already installed in `/etc/systemd/logind.conf.d/10-lid-suspend.conf`. Physical dock/lid behavior remains subject to desktop handling and hardware testing. Power-button action remains suspend. No change to lock timing.
