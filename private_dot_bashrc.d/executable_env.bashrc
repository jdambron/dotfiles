#!/bin/bash

# Make nvim the default editor
export VISUAL=nvim;
export EDITOR="$VISUAL";
# Improve bash history
export HISTCONTROL=erasedups:ignorespace;
export HISTIGNORE=" *:ls:cd:cd -:pwd:exit:date:* --help:* -h";
# "bat" as manpager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
