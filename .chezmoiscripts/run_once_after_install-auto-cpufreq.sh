#!/bin/bash

INSTALL_DIR="/opt/auto-cpufreq/source"

set -e
if [ ! -d "$INSTALL_DIR" ]; then
	sudo mkdir -p "$INSTALL_DIR"
	echo "Cloning auto-cpufreq..."
	sudo git clone https://github.com/AdnanHodzic/auto-cpufreq.git "$INSTALL_DIR"
	pushd "$INSTALL_DIR"
	trap popd EXIT
	echo "Running auto-cpufreq installer..."
	sudo ./auto-cpufreq-installer --install
	sudo /usr/local/bin/auto-cpufreq --install
fi
