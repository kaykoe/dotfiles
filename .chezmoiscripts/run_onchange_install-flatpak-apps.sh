#!/usr/bin/env bash
set -e
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak install flathub md.obsidian.Obsidian dev.vencord.Vesktop
sudo flatpak override --socket=wayland --socket=fallback-x11 md.obsidian.Obsidian
