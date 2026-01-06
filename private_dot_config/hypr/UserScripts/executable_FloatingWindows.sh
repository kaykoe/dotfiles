#!/bin/bash

STATE_FILE="/tmp/hypr_float_map"
SOCKET_PATH="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

touch "$STATE_FILE"

run_daemon() {

	handle_event() {
		case $1 in
		activewindowv2*)
			# Get info about the window that just gained focus
			new_window_info=$(hyprctl activewindow -j)
			is_new_floating=$(echo "$new_window_info" | jq -r '.floating')
			curr_ws=$(echo "$new_window_info" | jq -r '.workspace.name')

			# Logic: If focus has landed on a TILED window (or the desktop)
			if [[ "$is_new_floating" != "true" && "$curr_ws" != "null" ]]; then
				# Identify ALL floating windows currently on this workspace
				floating_addresses=$(hyprctl clients -j | jq -r ".[] | select(.workspace.name == \"$curr_ws\" and .floating == true) | .address")

				if [[ -n "$floating_addresses" ]]; then
					for addr in $floating_addresses; do
						# Update mapping for each window
						sed -i "/^$addr /d" "$STATE_FILE"
						echo "$addr $curr_ws" >>"$STATE_FILE"

						# Move to special workspace silently
						hyprctl dispatch movetoworkspacesilent "special,address:$addr"
					done
				fi
			fi
			;;
		closewindow*)
			# Clean up state file when windows are closed
			hyprctl dispatch cyclenext floating
			closed_addr="0x${1#*>>}"
			sed -i "/^$closed_addr /d" "$STATE_FILE"
			;;
		esac
	}

	# Listen to Hyprland IPC socket
	socat -U - UNIX-CONNECT:"$SOCKET_PATH" | while read -r line; do
		handle_event "$line"
	done
}

# Function to recall windows (Action mode)
run_recall() {
	# 1. Get data for the currently focused monitor
	monitor_data=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true)')

	# 2. Check for active special workspace on this monitor (GitHub #8594 method)
	special_ws=$(echo "$monitor_data" | jq -r '.specialWorkspace.name')

	if [[ -n "$special_ws" && "$special_ws" != "" && "$special_ws" != "null" ]]; then
		# If a special workspace is visible on the current monitor, hide it
		hyprctl dispatch togglespecialworkspace
		exit 0
	fi

	# 3. Get the base active workspace on this monitor
	curr_ws=$(echo "$monitor_data" | jq -r '.activeWorkspace.name')

	# Get all addresses mapped to the current workspace
	targets=$(awk -v ws="$curr_ws" '$2 == ws {print $1}' "$STATE_FILE" 2>/dev/null)

	if [[ -n "$targets" ]]; then
		# RECALL BEHAVIOR: Bring back windows belonging to this workspace
		for addr in $targets; do
			hyprctl dispatch movetoworkspace "$curr_ws,address:$addr"
			sed -i "/^$addr /d" "$STATE_FILE"
		done
	else
		# 3. ORIGINAL BEHAVIOR: Cycle focus based on current window state
		is_curr_floating=$(hyprctl activewindow -j | jq -r '.floating')

		if [ "$is_curr_floating" == "true" ]; then
			hyprctl dispatch cyclenext tiled
		else
			hyprctl dispatch togglespecialworkspace
		fi
	fi
}

minimize() {
	local window_info addr curr_ws
	window_info="$(hyprctl activewindow -j)"
	addr=$(echo "$window_info" | jq -r '.address')
	curr_ws=$(echo "$window_info" | jq -r '.workspace.name')
	sed -i "/^$addr /d" "$STATE_FILE"
	echo "$addr $curr_ws" >>"$STATE_FILE"
	hyprctl dispatch cyclenext floating

	hyprctl dispatch movetoworkspacesilent "special,address:$addr"

}

# Main entry point
case "$1" in
--daemon)
	run_daemon
	;;
--recall)
	run_recall
	;;
--minimize)
	minimize
	;;
*)
	echo "Usage: $0 {--monitor|--recall}"
	exit 1
	;;
esac
