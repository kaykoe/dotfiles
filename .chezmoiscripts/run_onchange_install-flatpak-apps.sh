#!/usr/bin/env bash
sudo flatpak install flathub md.obsidian.Obsidian dev.vencord.Vesktop
sudo flatpak override --socket=wayland --socket=fallback-x11 md.obsidian.Obsidian
