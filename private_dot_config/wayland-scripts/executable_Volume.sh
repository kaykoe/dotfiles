#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Scripts for volume controls for audio and mic

iDIR="$HOME/.config/swaync/icons"
waylandScripts="$HOME/.config/wayland-scripts"
volume_step_db=2

# Get the loudest output channel in dB. Relative dB changes scale every
# channel by the same ratio, preserving the balance configured in pavucontrol.
get_max_volume_db() {
	LC_ALL=C pactl get-sink-volume @DEFAULT_SINK@ | awk '
		{
			for (i = 1; i <= NF; i++) {
				if ($i ~ /^dB,?$/ && $(i - 1) != "-inf") {
					value = $(i - 1) + 0
					if (!found || value > maximum) {
						maximum = value
					}
					found = 1
				}
			}
		}
		END {
			if (found) {
				printf "%.2f\n", maximum
			}
		}'
}

# Get Volume
get_volume() {
	volume=$(pamixer --get-volume)
	if [[ "$volume" -eq "0" ]]; then
		echo "Muted"
	else
		echo "$volume %"
	fi
}

# Get icons
get_icon() {
	current=$(get_volume)
	if [[ "$current" == "Muted" ]]; then
		echo "$iDIR/volume-mute.png"
	elif [[ "${current%\%}" -le 30 ]]; then
		echo "$iDIR/volume-low.png"
	elif [[ "${current%\%}" -le 60 ]]; then
		echo "$iDIR/volume-mid.png"
	else
		echo "$iDIR/volume-high.png"
	fi
}

# Notify
notify_user() {
	if [[ "$(get_volume)" == "Muted" ]]; then
		notify-send -e -h string:x-canonical-private-synchronous:volume_notif -h boolean:SWAYNC_BYPASS_DND:true -u low -i "$(get_icon)" " Volume:" " Muted"
	else
		notify-send -e -h int:value:"$(get_volume | sed 's/%//')" -h string:x-canonical-private-synchronous:volume_notif -h boolean:SWAYNC_BYPASS_DND:true -u low -i "$(get_icon)" " Volume Level:" " $(get_volume)" &&
			"$waylandScripts/Sounds.sh" --volume
	fi
}

# Increase Volume
inc_volume() {
	if [ "$(pamixer --get-mute)" == "true" ]; then
		toggle_mute
	else
		max_db=$(get_max_volume_db)
		if [[ -z "$max_db" ]]; then
			# There is no ratio to preserve when every channel is at zero.
			pactl set-sink-volume @DEFAULT_SINK@ 1%
		else
			increase_db=$(awk -v maximum="$max_db" -v step="$volume_step_db" 'BEGIN {
				room = -maximum
				if (room <= 0) {
					print 0
				} else if (room < step) {
					printf "%.2f\n", room
				} else {
					print step
				}
			}')
			if awk -v increase="$increase_db" 'BEGIN { exit !(increase > 0) }'; then
				pactl set-sink-volume @DEFAULT_SINK@ "+${increase_db}dB"
			fi
		fi
		notify_user
	fi
}

# Decrease Volume
dec_volume() {
	if [ "$(pamixer --get-mute)" == "true" ]; then
		toggle_mute
	else
		pactl set-sink-volume @DEFAULT_SINK@ "-${volume_step_db}dB" && notify_user
	fi
}

# Toggle Mute
toggle_mute() {
	if [ "$(pamixer --get-mute)" == "false" ]; then
		pamixer -m && brightnessctl -d 'platform::mute' s 1 && notify-send -e -u low -h boolean:SWAYNC_BYPASS_DND:true -i "$iDIR/volume-mute.png" " Mute"
	elif [ "$(pamixer --get-mute)" == "true" ]; then
		pamixer -u && brightnessctl -d 'platform::mute' s 0 && notify-send -e -u low -h boolean:SWAYNC_BYPASS_DND:true -i "$(get_icon)" " Volume:" " Switched ON"
	fi
}

# Toggle Mic
toggle_mic() {
	if [ "$(pamixer --default-source --get-mute)" == "false" ]; then
		pamixer --default-source -m && brightnessctl -d 'platform::micmute' s 1 && notify-send -e -u low -h boolean:SWAYNC_BYPASS_DND:true -i "$iDIR/microphone-mute.png" " Microphone:" " Switched OFF"
	elif [ "$(pamixer --default-source --get-mute)" == "true" ]; then
		pamixer -u --default-source u && brightnessctl -d 'platform::micmute' s 0 && notify-send -e -u low -h boolean:SWAYNC_BYPASS_DND:true -i "$iDIR/microphone.png" " Microphone:" " Switched ON"
	fi
}
# Get Mic Icon
get_mic_icon() {
	current=$(pamixer --default-source --get-volume)
	if [[ "$current" -eq "0" ]]; then
		echo "$iDIR/microphone-mute.png"
	else
		echo "$iDIR/microphone.png"
	fi
}

# Get Microphone Volume
get_mic_volume() {
	volume=$(pamixer --default-source --get-volume)
	if [[ "$volume" -eq "0" ]]; then
		echo "Muted"
	else
		echo "$volume %"
	fi
}

# Notify for Microphone
notify_mic_user() {
	volume=$(get_mic_volume)
	icon=$(get_mic_icon)
	notify-send -e -h int:value:"$volume" -h "string:x-canonical-private-synchronous:volume_notif" -h boolean:SWAYNC_BYPASS_DND:true -u low -i "$icon" " Mic Level:" " $volume"
}

# Increase MIC Volume
inc_mic_volume() {
	if [ "$(pamixer --default-source --get-mute)" == "true" ]; then
		toggle_mic
	else
		pamixer --default-source -i 5 && notify_mic_user
	fi
}

# Decrease MIC Volume
dec_mic_volume() {
	if [ "$(pamixer --default-source --get-mute)" == "true" ]; then
		toggle-mic
	else
		pamixer --default-source -d 5 && notify_mic_user
	fi
}

# Execute accordingly
if [[ "$1" == "--get" ]]; then
	get_volume
elif [[ "$1" == "--inc" ]]; then
	inc_volume
elif [[ "$1" == "--dec" ]]; then
	dec_volume
elif [[ "$1" == "--toggle" ]]; then
	toggle_mute
elif [[ "$1" == "--toggle-mic" ]]; then
	toggle_mic
elif [[ "$1" == "--get-icon" ]]; then
	get_icon
elif [[ "$1" == "--get-mic-icon" ]]; then
	get_mic_icon
elif [[ "$1" == "--mic-inc" ]]; then
	inc_mic_volume
elif [[ "$1" == "--mic-dec" ]]; then
	dec_mic_volume
else
	get_volume
fi
