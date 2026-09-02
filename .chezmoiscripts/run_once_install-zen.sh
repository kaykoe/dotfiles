#!/usr/bin/env bash

set -eo pipefail
curl -fsSL https://updates.zen-browser.app/install.sh | bash
update-alternatives --set x-www-browser ~/.local/bin/zen
xdg-settings set default-web-browser microsoft-edge.desktop
