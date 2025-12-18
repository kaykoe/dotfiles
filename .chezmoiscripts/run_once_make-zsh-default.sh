#!/usr/bin/env bash

set -e

echo -e 'Setting zsh as default shell..\n'
sudo chsh -s "$(which zsh)" "$USER"
sudo chsh -s "$(which zsh)" root
