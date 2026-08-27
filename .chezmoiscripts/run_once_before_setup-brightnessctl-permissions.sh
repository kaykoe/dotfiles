#!/usr/bin/env bash

set -euo pipefail

sudo usermod -a -G video $USER
newgrp video
sudo usermod -a -G input $USER
newgrp input
