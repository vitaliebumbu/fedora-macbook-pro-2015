# Bambu Studio

Installed system-wide from Flathub on 2026-10-14: Bambu Studio 2.8.2.61 Public Release, application ID `com.bambulab.BambuStudio`, GNOME Platform 50 runtime. Installation completed successfully and the app was launched; running Flatpak processes were confirmed. Startup log contains GTK window-resize warnings, so successful process startup is not a complete UI/slicing test.

```bash
flatpak install --system flathub com.bambulab.BambuStudio
flatpak run com.bambulab.BambuStudio
```

Choose your printer and filament profiles in the first-run setup. No account login, network-plugin agreement, printer pairing, slicing, or print job was performed. Printing configuration is private and is not backed up to this public repository.

App installed size was approximately 1 GB, with additional shared Flatpak runtimes. Update using `flatpak update com.bambulab.BambuStudio`. Uninstall using `flatpak uninstall com.bambulab.BambuStudio`; do not delete application data unless you intend to remove saved profiles/projects. Review unused runtimes with `flatpak uninstall --unused` before accepting removals.

References: [Flathub listing](https://flathub.org/en/apps/com.bambulab.BambuStudio), [upstream project](https://github.com/bambulab/BambuStudio).
