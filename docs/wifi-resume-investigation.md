# Wi-Fi failure before reboot — 2026-10-17

Previous boot journal shows normal connection until suspend at17:57:44, resume17:58:24. Immediately afterward brcmfmac firmware-command responses timed out, channel/tx-power queries failed-5, NetworkManager supplicant initialization timed out, and scans failed with input/output error-5. Wi-Fi radio was disabled around18:00:30–35, after the failure; reboot followed18:01.

Evidence points to BCM43602 driver/firmware failing to recover after deep sleep, rather than a password/DHCP problem. Exact firmware-versus-driver cause is not established. Existing powersave-off workaround is insufficient to establish reliable resume. Current boot Wi-Fi connected and power save off. No network or sleep configuration changed during investigation; no live driver reload or forced suspend performed.

Next candidate is a targeted post-resume recovery (reload/rebind only if adapter fails), with physical sleep/wake testing. It is not installed by this investigation. Prioritized over changing credentials or disabling unrelated boot optimizations.
