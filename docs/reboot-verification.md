## Reboot verification — 2026-10-14

- Booted kernel7.2.10; systemd startup14.901s (firmware/visible readiness excluded).
- Touchpad adaptive/-0.15, natural scrolling, tap/click settings, WhiteSur24 cursor and gascroll0.50 retained; library mapped in GNOME Shell.
- Keyboard swap_ctrl_cmd1/fnmode1, screenshot bindings, Firefox session-restore user.js, DNF config, mpv config and journal limits retained.
- Wi-Fi connected under macbook-powersave, Wi-Fi powersave off. Bluetooth timer, fan/thermal, cache-clean and TRIM enablement retained. Vitals active.
- Camera DKMS installed, /dev/video0 present, 10-frame capture exited0; FFmpeg emitted a duplicate timestamp warning. Lid policy/deep-sleep configuration retained; physical suspend/wake not retested.
- EasyEffects startup did not restore approved sound: old Warm Music and bypass on. Updated startup to wait for physical speaker device, parse sink JSON instead of a shell pipeline, and retry/verify preset+bypass. Manual corrected path reports Balanced Bass/bypass2; next reboot remains pending.
- Bluetooth controller reset timeout -110 after boot. Reloading btusb did not recover it. Targeted USB reset of05ac:8290 returned success; Controller available. No permanent Bluetooth recovery change applied; pairing/audio not tested.
- Reboot persistence is verified for listed settings, not every application/hardware behavior. Actual playback, mouse feel, Bluetooth pairing and battery reporting are not established by config checks.
