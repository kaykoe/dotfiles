#!/usr/bin/env bash

echo -e 'Setting zsh as default shell..\n'
sudo chsh -s "$(which zsh)"
sudo chsh -s "$(which zsh)" root
