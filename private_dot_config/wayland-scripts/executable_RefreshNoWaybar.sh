#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##

# Modified version of Refresh.sh but waybar wont refresh
# Used by automatic wallpaper change
# Modified inorder to refresh rofi background, Wallust, SwayNC only

SCRIPTSDIR=$HOME/.config/wayland-scripts

# Kill already running processes
_ps=(rofi)
for _prs in "${_ps[@]}"; do
	if pidof "${_prs}" >/dev/null; then
		pkill "${_prs}"
	fi
done

# quit ags & relaunch ags
#ags -q && ags &

# quit quickshell & relaunch quickshell
#pkill qs && qs &

# Wallust refresh
${SCRIPTSDIR}/WallustSwww.sh &

# reload swaync
swaync-client --reload-config

# Relaunching rainbow borders if the script exists

# UserScripts=$HOME/.config/hypr/UserScripts
# sleep 1
# [[ -e "${UserScripts}/RainbowBorders.sh" ]] &&  "${UserScripts}/RainbowBorders.sh" &

exit 0
