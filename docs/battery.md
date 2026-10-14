# Battery reporting and charger diagnosis

Investigated percentage jumps and alternating charging/discharging on 2026-10-13. The connected adapter was reported by the user as 60W MagSafe 2; Apple's specification for this 15-inch model is 85W MagSafe 2.

## Observations

- Initial samples showed continuous AC detection and increasing stored charge.
- Later samples showed `ADP1/online=1` while the battery reported Discharging, with decreasing charge. A connected adapter is therefore not proof that the battery is charging.
- Raw capacity was about 30% while charge_now/charge_full was approximately 37%. Raw capacity matched charge_now/design capacity instead.
- An [upstream ACPI SBS patch proposal](https://lists.openwall.net/linux-kernel/2026/09/03/1310) describes exporting absolute state of charge instead of relative state of charge. This matches the observed mismatch; patch presence in the installed kernel was not established.
- Restarting UPower refreshed reported percentage from approximately 35.9% to 46.8%. Raw charge readings also shifted; stale information and/or battery-gauge recalculation remain possibilities. This was not a verified repair.

## Next steps

Compare with a known-good 85W MagSafe 2 adapter. If charging/reporting remains erratic, inspect the connector and port with power disconnected and consider an SMC reset using [Apple's non-T2 Intel laptop instructions](https://support.apple.com/en-us/102605): shut down, hold physical left Shift+Control+Option and Power for 10 seconds, release, then start. The Linux Command/Control remapping does not change the physical keys used while shut down.

No custom kernel patch, power-profile change, charging threshold, or SMC reset was applied. Do not force deep battery discharge to troubleshoot the gauge. If issues persist with a known-good correct adapter and controller reset, battery or charging hardware needs further diagnosis.

Reference: [model specifications](https://support.apple.com/en-us/111955). Adapter insufficiency is plausible, not proved solely by its wattage; intermittent contacts, controller state, and battery condition remain alternatives.
