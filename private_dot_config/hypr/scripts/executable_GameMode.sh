#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Game Mode. Turning off all animations

notif="$HOME/.config/swaync/images/ja.png"
SCRIPTSDIR="$HOME/.config/hypr/scripts"

read -r _ EYECANDY_ENABLED < <(hyprctl getoption decoration:rounding)
if [[ "$EYECANDY_ENABLED" -ne 0 ]]; then
	hyprctl --batch "\
    keyword animations:enabled 0;\
    keyword animation borderangle,0; \
    keyword decoration:shadow:enabled 0;\
    keyword decoration:blur:enabled 0;\
    keyword decoration:fullscreen_opacity 1;\
    keyword general:gaps_in 0;\
    keyword general:gaps_out 0;\
    keyword general:border_size 1;\
    keyword decoration:rounding 0"
	hyprctl keyword "windowrule opacity 1 override 1 override 1 override, ^(.*)$"
	swww kill
	notify-send -e -u low -i "$notif" " Gamemode:" " enabled"
	exit
else
	swww-daemon --format xrgb && swww img "$HOME/.config/rofi/.current_wallpaper" &
	sleep 0.1
	${SCRIPTSDIR}/WallustSwww.sh
	sleep 0.5
	${SCRIPTSDIR}/Refresh.sh
	hyprctl reload
	notify-send -e -u normal -i "$notif" " Gamemode:" " disabled"
	exit
fi
