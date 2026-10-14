#!/usr/bin/env bash
set -euo pipefail
gsettings set org.gnome.desktop.session idle-delay 1800
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 2700
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 2700
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type suspend
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type suspend
