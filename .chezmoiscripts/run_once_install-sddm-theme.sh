#!/usr/bin/env bash

set -e

source_theme="https://github.com/JaKooLit/simple-sddm-2.git"
theme_name="simple_sddm_2"
#
# Clone the repository
pushd /tmp
trap popd EXIT

git clone --depth=1 "$source_theme" "$theme_name"
sudo mkdir -p /usr/share/sddm/themes
sudo mv "$theme_name" "/usr/share/sddm/themes/$theme_name" 2>&1

# setting up SDDM theme
sddm_conf="/etc/sddm.conf"
BACKUP_SUFFIX=".bak"

if [ -f "$sddm_conf" ]; then
	sudo cp "$sddm_conf" "$sddm_conf$BACKUP_SUFFIX" 2>&1
else
	sudo touch "$sddm_conf" 2>&1
fi

# Check if the [Theme] section exists
if grep -q '^\[Theme\]' "$sddm_conf"; then
	# Update the Current= line under [Theme]
	sudo sed -i "/^\[Theme\]/,/^\[/{s/^\s*Current=.*/Current=$theme_name/}" "$sddm_conf" 2>&1

	# If no Current= line was found and replaced, append it after the [Theme] section
	if ! grep -q '^\s*Current=' "$sddm_conf"; then
		sudo sed -i "/^\[Theme\]/a Current=$theme_name" "$sddm_conf" 2>&1
	fi
else
	# Append the [Theme] section at the end if it doesn't exist
	echo -e "\n[Theme]\nCurrent=$theme_name" | sudo tee -a "$sddm_conf" >/dev/null
fi

# Add [General] section with InputMethod=qtvirtualkeyboard if it doesn't exist
if ! grep -q '^\[General\]' "$sddm_conf"; then
	echo -e "\n[General]\nInputMethod=qtvirtualkeyboard" | sudo tee -a "$sddm_conf" >/dev/null
else
	# Update InputMethod line if section exists
	if grep -q '^\s*InputMethod=' "$sddm_conf"; then
		sudo sed -i '/^\[General\]/,/^\[/{s/^\s*InputMethod=.*/InputMethod=qtvirtualkeyboard/}' "$sddm_conf" 2>&1
	else
		sudo sed -i '/^\[General\]/a InputMethod=qtvirtualkeyboard' "$sddm_conf" 2>&1
	fi
fi

# Replace current background from assets
sudo sed -i 's|^wallpaper=".*"|wallpaper="Backgrounds/default"|' "/usr/share/sddm/themes/$theme_name/theme.conf" 2>&1

# copying font to global dir so the theme has access to it
sudo mkdir -p /usr/local/share/fonts/JetBrainsMonoNerd &&
	popd
pushd "$HOME/.local/share/fonts/"
find . -type f -regex '\./JetBrainsMonoNerdFont[A-Za-z\-]+\.ttf' -print0 |
	xargs -0 sudo cp -t /usr/local/share/fonts/JetBrainsMonoNerd

fc-cache -v -f 2>&1
