#!/usr/bin/env bash

copyparty_url='https://files.kaykoe.ovh/'
copyparty_wallpaper_folder='priv/wallpapers'
copyparty_username='kaykoe'

echo 'Fetching wallpaper dir from copyparty'
wget -O- --user="$copyparty_username" --ask-password "${copyparty_url}${copyparty_wallpaper_folder}?tar" | tar -C ~/Pictures/ -x
